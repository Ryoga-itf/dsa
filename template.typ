#let textL = 1.8em
#let textM = 1.6em
#let fontSerif = ("Noto Serif", "Noto Serif CJK JP")
#let fontSan = ("Noto Sans", "Noto Sans CJK JP")

#let project(week: -1, name: "", authors: (), deadline: none, date: none, body) = {
  let title = "データ構造とアルゴリズム実験レポート"
  let subtitle = "課題" + str(week) + "：" + name

  set document(author: authors.map(a => a.name), title: title)
  set page(numbering: "1 / 1", number-align: center)
  set text(font: fontSerif, lang: "ja")
  show raw: set text(font: ("Hack Nerd Font Mono", "Noto Sans Mono CJK JP"))

  show heading: set text(font: fontSan, weight: "medium", lang: "ja")
  show heading.where(level: 1): it => {
    set text(size: 1.4em)
    pad(top: 3em, bottom: 1em)[
      #it
    ]
  }
  show heading.where(level: 2): it => pad(top: 1em, bottom: 0.6em, it)

  // Figure
  show figure: it => pad(y: 1em, it)
  show figure.caption: it => pad(top: 0.6em, it)
  show figure.caption: it => text(size: 0.8em, it)

  // Title row.
  align(center)[
    #block(text(textL, weight: 700, title))
    #block(text(textM, weight: 700, subtitle))
    #v(1em, weak: true)
  ]

  // Author information.
  pad(
    top: 0.5em,
    bottom: 0.5em,
    x: 2em,
    grid(
      columns: (1fr,) * calc.min(3, authors.len()),
      gutter: 1em,
      ..authors.map(author => align(center)[
        *#author.name* \
        学籍番号: #author.id \
        所属: #author.affiliation \
      ]),
    ),
  )

  // Date
  align(center)[
    締切日：#deadline \
    提出日：#date \
  ]

  // Main body.
  set par(justify: true)

  body
}
