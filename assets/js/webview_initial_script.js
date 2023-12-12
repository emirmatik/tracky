// function getPathTo(element) {
//     // Selector
//     let selector = '';
//     // Loop handler
//     let foundRoot;
//     // Element handler
//     let currentElement = element;

//     // Do action until we reach html element
//     do {
//         // Get element tag name 
//         const tagName = currentElement.tagName.toLowerCase();
//         // Get parent element
//         const parentElement = currentElement.parentElement;

//         // Count children
//         if (parentElement.childElementCount > 1) {
//             // Get children of parent element
//             const parentsChildren = [...parentElement.children];
//             // Count current tag 
//             let tag = [];
//             parentsChildren.forEach(child => {
//                 if (child.tagName.toLowerCase() === tagName) tag.push(child) // Append to tag
//             })

//             // Is only of type
//             if (tag.length === 1) {
//                 // Append tag to selector
//                 selector = `/${tagName}${selector}`;
//             } else {
//                 // Get position of current element in tag
//                 const position = tag.indexOf(currentElement) + 1;
//                 // Append tag to selector
//                 selector = `/${tagName}[${position}]${selector}`;
//             }

//         } else {
//             //* Current element has no siblings
//             // Append tag to selector
//             selector = `/${tagName}${selector}`;
//         }

//         // Set parent element to current element
//         currentElement = parentElement;
//         // Is root  
//         foundRoot = parentElement.tagName.toLowerCase() === 'html';
//         // Finish selector if found root element
//         if (foundRoot) selector = `/html${selector}`;
//     }
//     while (foundRoot === false);

//     // Return selector
//     return selector;
// }

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


// id("corePriceDisplay_mobile_feature_div")/div[1]/span[2]/span[2]
// *[@id="corePriceDisplay_mobile_feature_div"]/div[1]/span[2]/span[2]
//*[@id="corePriceDisplay_mobile_feature_div"]/div[1]/span[2]/span[2]
//*[@id="corePriceDisplay_mobile_feature_div"]/div[1]/span[2]/span[2]

const allElementsOnPage = [...document.querySelectorAll('*')];

allElementsOnPage.forEach(node => node.addEventListener('click', e => {
    e.stopPropagation();
    e.preventDefault();

    if (node.tagName === 'BUTTON' || node.tagName === 'INPUT' || node.tagName === 'A') {
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