function getPathTo(element) {
    const idx = (sib, name) => sib
        ? idx(sib.previousElementSibling, name || sib.localName) + (sib.localName == name)
        : 1;
    const segs = elm => !elm || elm.nodeType !== 1
        ? ['']
        : elm.id && document.getElementById(elm.id) === elm
            ? [`//*[@id="${elm.id}"]`]
            : [...segs(elm.parentNode), `${elm.localName.toLowerCase()}[${idx(elm)}]`];
    return segs(element).join('/');
}

const allElementsOnPage = [...document.querySelectorAll('*')];

allElementsOnPage.forEach(node => node.addEventListener('click', e => {
    e.stopPropagation();
    e.preventDefault();

    if (node.tagName.toLowerCase().includes('button')) {
        return null;
    }

    const prevSelected = document.querySelector('.selectedByTracky');

    if (prevSelected) {
        if (prevSelected.classList.contains('doneByTracky')) return null;
        prevSelected.classList.remove('selectedByTracky');
    }

    node.classList.add('selectedByTracky');

    // call the flutter fn to change the selected element
    const item = {
        xpath: getPathTo(node),
        html: node.innerHTML
    }
    window.flutter_inappwebview.callHandler('selectItem', item);
}));