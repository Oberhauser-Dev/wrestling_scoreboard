{{flutter_js}}
{{flutter_build_config}}

// Set the theme from the URL param, with fallback to user preference if no theme is
// specified.
const queryParams = new URLSearchParams(window.location.search);

let theme = queryParams.get("brightness");
theme ||= window.matchMedia("(prefers-color-scheme: dark)").matches ? "dark" : "light";
document.body.classList.add(theme);

const splashScreenStyle = document.createElement('style');
splashScreenStyle.textContent = `
  /* Background */
  body.light {
    background-color: #E6EBEB;
  }

  body.dark {
    background-color: #121212;
  }

  /* Loading indicator */
  body {
    inset: 0;
    overflow: hidden;
    margin: 0;
    padding: 0;
    position: fixed;
  }

  #loading {
    align-items: center;
    display: flex;
    height: 100%;
    justify-content: center;
    width: 100%;
  }

  #loading img {
    animation: 1s ease-in-out 0s infinite alternate breathe;
    opacity: .66;
    transition: opacity .4s;
  }

  #loading.main_done img {
    opacity: 1;
  }

  #loading.init_done img {
    animation: .33s ease-in-out 0s 1 forwards zooooom;
    opacity: .05;
  }

  @keyframes breathe {
    from { transform: scale(1); }
    to { transform: scale(0.95); }
  }

  @keyframes zooooom {
    from { transform: scale(1); }
    to { transform: scale(0.01); }
  }
`;
document.head.appendChild(splashScreenStyle);

const loading = document.createElement('div');
loading.id = 'loading';

const indicator = document.createElement('img');
indicator.alt = 'Loading indicator...';
indicator.src = 'icons/Icon-192.png';
indicator.height = 100;

loading.appendChild(indicator);
document.body.appendChild(loading);

// See example for progress indicator:
// https://docs.flutter.dev/platform-integration/web/initialization#example-display-a-progress-indicator
_flutter.loader.load({
  onEntrypointLoaded: async function (engineInitializer) {
    loading.classList.add('main_done');
    const appRunner = await engineInitializer.initializeEngine();
    loading.classList.add('init_done');

    await appRunner.runApp();

    // Wait a few milliseconds so users can see the "zoooom" animation
    // before getting rid of the "loading" div.
    window.setTimeout(function () {
      loading.remove();
    }, 200);
  }
});
