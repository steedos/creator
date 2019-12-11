/**
 * keepnox:perfect-scrollbar 是根据window.onwheel 是否等于 undefined 来决定用wheel事件还是mousewheel。
 * 在 IE 浏览器中，只能通过 addEventListener() 方法支持 wheel 事件。 在 DOM 对象中没有 onwheel 属性。
 * 此处手动将window.onwheel值设置为null，使其在IE中也通过wheel事件来处理滚动条。
 * @type {null}
 */
window.onwheel = null;