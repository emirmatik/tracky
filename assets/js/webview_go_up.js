(function () {
    const selected = document.querySelector('.selectedByTracky');

    if (selected.parentElement) {
        selected.classList.remove('selectedByTracky');

        selected.parentElement.classList.add('selectedByTracky');

        // call the flutter fn to change the selected element
        const item = {
            xpath: getPathTo(selected.parentElement),
            html: selected.parentElement.innerHTML
        }
        window.flutter_inappwebview.callHandler('selectItem', item);
    }
})()
