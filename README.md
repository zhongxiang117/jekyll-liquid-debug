# Jekyll Liquid Debug

This program is created to **debug** [`shopify-liquid-template`](https://shopify.github.io/liquid/), which is a type of programing language mainly used to generate static website, especially for [`Jekyll`](https://jekyllrb.com/).


## Installation

To install, execute,

```ruby
gem install 'jekyll-liquid-debug'
```


## Reason of Creation

Jekyll is an awesome static website generator, it uses `liquid` for coding. However, `liquid` works like a **black-box**, it is not command-line-aware, all those magic things are happening in the backend.

Many time, we just want to see through what is happening of a single line or a very small piece of snippets, like for many interpreting languages, `print debug-info`. However, `liquid` does not allow us to do this.

Thus, every time we have to **build & debug** the whole site again and again. It is way too time consuming, and also needing great patiences and efforts. This, definitely, is not what we expected.

So, it comes to this package.

With it, you can simply run your `liquid` file in your terminal, to help check either semantic or functioning errors.


## Usage

After you successfully installed, show help message,

```
jekyll-liquid-debug -h
```

The options in **Input files** will look like,

```
-f, --file [FILE]                input liquid template
-t, --html [FILE]                input html template
-y, --yaml [FILE]                input YAML file, parsed to `site.[var]'
-k, --md [FILE]                  input raw markdown file, precedent for option `-t'
    --out-html                   output html file, overwrite may happen
    --out-md                     output markdown file, overwrite may happen
```

They are self-explanation.


## Examples

### Write out default markdown file

To help developments, a **default** markdown file is created. This file includes all the `Markdown syntax`s used to convert **HTML** file, and to boost debugging, each of those **Text Formatting** is repeated in three times.

To have a look of this file, run

```
jekyll-liquid-debug --out-md
```


### Debug Liquid Template

If you have a `liquid` coded file, `myfile.liquid`

```
{%- assign my_variable = false -%}
{%- assign my_number = 10 -%}
{%- if my_variable == true -%}
    {{ my_number | plus: 1 }}
{%- else -%}
    {{ my_number | minus: 1 }}
{%- endif -%}

{{}}
Debug my_number: {{ my_number }}
```

You want to printout `my_number`, you can run,

```
jekyll-liquid-debug -f myfile.liquid
```

Then you will see,

```
Note: using default markdown file < jekyll-markdown.md >
9
Debug my_number: 10
```

**Note:** empty command `{{}}` in `liquid` works like starting a new line. For more, please refer to [`shopify-liquid-template`](https://shopify.github.io/liquid/). It's mainly used to _separate_ the debug info and other leading messages from white-space-controlling. Otherwise, your debug info may be printed out at the same line.

I also have a post about the [`liquid-white-space-control`](https://zhongxiang117.github.io/Jekyll/Things-Need-To-Know/liquid-whitespace.html)


### Debug Liquid Template With Raw Markdown As Input

So what will happen if you want to code a `liquid` with the `YAML` & `Markdown` file?

The answer is you can use it as the input.

Please be aware of that, the `Markdown` file you input will be parsed using variables defined `YAML` file first, and then converted to `html` file at background, then the new variable `content` will be generated, which you can invoke inside the `liquid`.

For example, if you have a `_config.yml` file,

```
debug: true

editor:
  windows : notepad
  ubuntu  : gedit
  mac     : textedit
```

you have a `Markdown` file, which is under a name `myMarkdown.md`,

```
{%- if site.debug -%}
    {{ site.editor.windows }}
    {{ site.editor.ubuntu }}
    {{ site.editor.mac }}
{%- endif %}

Good good **study**, day day **up**.

Add oil!

Today is a good day, people mountain people sea.

Know is **know**, noknow is noknow.
```

If you want to remove the `<strong></strong>` tag for words `study` & `up` & `know` after they are converted to `THML`, you can do this, inside your `myfile.liquid`, using **filter** simply `replace` those tags to be empty.

```
{{ content | replace: "<strong>", "" | replace: "</strong>", "" }}
```

Run,

```
jekyll-liquid-debug -f myfile.liquid -m myMarkdown.md -y _config.yml
```

**Note:** you can also only convert your raw `Markdown` to `HTML`, by using `jekyll-liquid-debug -m myMarkdown.md --out-html`.


### Debug Liquid Template With HTML As Input

It works similar like using `Markdown` as the input, with the changing of option,

```
jekyll-liquid-debug -f myfile.liquid -t myHTML.html
```

**Warning:** When both `-t` & `-m` are specified, only your Markdown file for `-m` will be parsed into `liquid` as the variable `content`.


### Show Development Feature

```
jekyll-liquid-debug --feature
```


## Dependency

```
gem install liquid
gem install kramdown
```


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/zhongxiang117/jekyll-liquid-debug.

