function resizeToEqualHeight(resizeClass, referenceClass) {
  var resizeObject = document.getElementsByClassName(resizeClass)[0];
  var width = window.getComputedStyle(resizeObject).borderRightWidth;
  if (width != "" && width != "0px") {
    var referenceObject = document.getElementsByClassName(referenceClass)[0];
    resizeObject.style.height = referenceObject.clientHeight + "px";
  }
  else {
    resizeObject.style.height = "";
  }
}
