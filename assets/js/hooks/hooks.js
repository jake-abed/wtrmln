const Hooks = {}

Hooks.FormReset = {
  updated() {
    let input = document.querySelector('#message')
    console.log(input)
    let value = input.getAttribute('phx-reset')
    input.value = value
  }
}

export default Hooks
