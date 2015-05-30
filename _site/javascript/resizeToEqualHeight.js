function resizeToEqualHeight(resizeClass, referenceClass) {
  var resizeObject = document.getElementsByClassName(resizeClass)[0];
  var width = window.getComputedStyle(resizeObject).borderRightWidth;
  if (width != "" && width != "0px") {
    var referenceObject = document.getElementsByClassName(referenceClass)[0];
    if (resizeObject.clientHeight < referenceObject.clientHeight) {
      resizeObject.style.height = referenceObject.clientHeight + "px";
    }
  }
  else {
    resizeObject.style.height = "";
  }
}
