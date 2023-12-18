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

const initialCode = async () => {
    await new Promise(res => setTimeout(res, 1000));

    const allElementsOnPage = [...document.querySelectorAll('*')];
    const elementWithClick = [];

    allElementsOnPage.forEach(node => {
        if (node.onclick) {
            elementWithClick.push(node);
            return;
        }
        
        node.addEventListener('click', e => {
            e.stopPropagation();
            e.preventDefault();

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
            return false;
        })
    });

    elementWithClick.forEach(node => {
        const children = node.querySelectorAll('*');

        children.forEach(child => child.onclick = null);
    });
}

if (document.readyState !== 'loading') {
    initialCode();
} else {
    window.addEventListener('DOMContentLoaded', initialCode)
}
