# nim js -o=spa.js spa.nim
import dom, jsconsole, react, future

type
  Greet = ref object of RootObj
    name: cstring
  Greetings = ref object of StatelessComponent[Greet]
  MultiGreet = ref object of RootObj
    name1, name2: cstring
  Choice = ref object
    first: bool
  MultiGreetings = ref object of Component[MultiGreet, Choice]

proc greetings(): ReactComponent =
  defineComponent:
    proc renderComponent(g: Greetings): auto = p(
      Attrs(style: Style(color: "red"), onClick: () => console.log("clicked")),
      "Hello ",
      g.props.name
    )

    proc componentWillMount(g: Greetings) = console.log("Mounting")

    proc componentDidMount(g: Greetings) = console.log("Mounted")

    proc componentWillReceiveProps(g: Greetings, p: Greet) = console.log(p)

proc multigreetings(): ReactComponent =
  defineComponent:
    proc renderComponent(m: MultiGreetings): auto =
      let g = greetings()
      if m.state.first:
        React.createElement(g, Greet(name: m.props.name1))
      else:
        React.createElement(g, Greet(name: m.props.name2))

    proc componentWillMount(m: MultiGreetings) =
      discard window.setTimeout(() => m.setState(Choice(first: true)), 1000)

    proc getInitialState(props: MultiGreet): auto =
      Choice(first: false)

proc startApp() {.exportc.} =
  console.log React.version
  let
    content = document.getElementById("content")
    Hello = React.createElement(multigreetings(), MultiGreet(name1: "Andrea", name2: "pippo"))
  ReactDOM.render(Hello, content)