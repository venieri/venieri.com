export default InfiniteScroll = {
    page() {return this.el.dataset.page;},
    loadMore(entries) {
      const target = entries[0];
      if (target.isIntersecting && this.pending == this.page()) {
        this.pending = this.page() + 1;
        this.pushEvent("load-more", {});
      }
    },
    mounted() {
      this.pending = this.page();
      this.observer = new IntersectionObserver(
        (entries) => this.loadMore(entries),
        {
          root: null, // window by default
          rootMargin: "400px",
          threshold: 0.1,
        }
      );
      this.observer.observe(this.el);
    },
    destroyed() {
      this.observer.unobserve(this.el);
    },
    updated() {
      this.pending = this.page();
    },
  };