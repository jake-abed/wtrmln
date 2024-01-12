const Hooks = {}

Hooks.FormReset = {
  updated() {
    let input = document.querySelector('#message')
    console.log(input)
    let value = input.getAttribute('phx-reset')
    input.value = value
  }
}

Hooks.MessageAdded = {
  mounted() {
    this.el.scrollIntoView({ behavior: "smooth" });
  }
}

export default Hooks
