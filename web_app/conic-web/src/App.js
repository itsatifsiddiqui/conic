import HomePage from "./pages/HomePage";

function App() {
  // const windowUrl = window.location.href;
  // console.log(window.location.origin);
  // console.log(windowUrl);
  // if (windowUrl.includes('android')) {
  //   console.log("OPENED ON ANDROID");
  //   const origin = window.location.origin;
  //   console.log(`ORIGIN: ${origin}`)

  //   const splitted = windowUrl.split('/');
  //   const userId = splitted[splitted.length - 1];
  //   const redirectUrl = `https://conic.page.link/${userId}`;

  //   console.log(redirectUrl);

  //   window.location.replace(redirectUrl);
  // }


  return (
    <div  >
      <style jsx global>{`
      body {
        margin: 0px;
        padding: 0px;
      }
    `}</style>
      < HomePage />
    </div>

  );
}

export default App;