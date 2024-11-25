---
title: "Paged HTML Document"
author: "NF Katzke"
date: "November 2021"
# date: "2024-11-24"
bibliography: Tex/ref.bib       # Do not edit: Keep this naming convention and location.
output:
  pagedown::html_paged:
    # template: wp_paged.html
    # css: ['wp.css', 'wp-fonts.css', 'wp-page.css']
    css: ["Template/default-fonts-Texevier.css", "Template/default-page-Texevier.css", "Template/default-Texevier.css"]
    csl: Template/harvard-stellenbosch-university.csl # referencing format used.
    template: ["Template/paged-Texevier.html"]

    toc: true
    # change to true for a self-contained document, but it'll be a litte slower for Pandoc to render
    self_contained: TRUE
abstract: |
    This is an abstract. Much can be written here. Uncomment this line to go without an abstract.
    Abstracts have no spaces, but can have bullets.

    Bullets can be created as follows

    + You can add bullets, but do not add colons please.

    + Line breaks are also not permitted.

---



\newpage

# Introduction {-}

This template has been adapted from pagedown::html_paged and is intended to help you simply create HTML that has a readable (pdf) feel to it.

References are to be made as follows: [@fama1997] and @grinold2000 Such authors could also be referenced in brackets [@grinold2000] and together [@fama1997 \& @grinold2000]. Source the reference code from scholar.google.com by clicking on ``cite'' below article name. Then select BibTeX at the bottom of the Cite window, and proceed to copy and paste this code into your ref.bib file, located in the directory's Tex folder. Open this file in Rstudio for ease of management, else open it in your preferred Tex environment. Add and manage your article details here for simplicity - once saved, it will self-adjust in your paper.

> I suggest renaming the top line after \@article, as done in the template ref.bib file, to something more intuitive for you to remember. Do not change the rest of the code. Also, be mindful of the fact that bib references from google scholar may at times be incorrect. Reference Latex forums for correct bibtex notation.

Writing in Rmarkdown is surprizingly easy - see [this website](https://www.rstudio.com/wp-content/uploads/2015/03/rmarkdown-reference.pdf) cheatsheet for a summary on writing Rmd writing tips.

# Data  {-}

Notice how I used the curly brackets and dash to remove the numbering of the data section.

Discussion of data should be thorough with a table of statistics and ideally a figure.

In your tempalte folder, you will find a Data and a Code folder. In order to keep your data files neat, store all of them in your Data folder. Also, I strongly suggest keeping this Rmd file for writing and executing commands, not writing out long pieces of data-wrangling. In the example below, I simply create a ggplot template for scatter plot consistency. I suggest keeping all your data in a data folder.

<!-- The following is a code chunk. It must have its own unique name (after the r), or no name. After the comma follows commands for R which are self-explanatory. By default, the code and messages will not be printed in your pdf, just the output: -->

<img src="Question_1_files/figure-html/unnamed-chunk-1-1.png" width="672" />





#  Methodology \label{Meth} {-}

## Subsection {-}
Ideally do not overuse subsections. It equates to bad writing.^[This is an example of a footnote by the way. Something that should also not be overused.]

## Math section {-}

Equations should be written as such:

\begin{align}
\beta = \sum_{i = 1}^{\infty}\frac{\alpha^2}{\sigma_{t-1}^2} \label{eq1} \\
\int_{x = 1}^{\infty}x_{i} = 1 \notag
\end{align}

If you would like to see the equations as you type in Rmarkdown, use $ symbols instead (see this for yourself by adjusted the equation):

$$
\beta = \sum_{i = 1}^{\infty}\frac{\alpha^2}{\sigma_{t-1}^2} \\
\int_{x = 1}^{\infty}x_{i} = 1
$$

Writing nice math requires practice. Note I used a forward slashes to make a space in the equations. I can also align equations using  __\&__, and set to numbering only the first line. Now I will have to type ``begin equation'' which is a native \LaTeX command. Here follows a more complicated equation:


\begin{align}
	y_t &= c + B(L) y_{t-1} + e_t   \label{eq2}    \\ \notag
	e_t &= H_t^{1/2}  z_t ; \quad z_t \sim  N(0,I_N) \quad \& \quad H_t = D_tR_tD_t \\ \notag
		D_t^2 &= {\sigma_{1,t}, \dots, \sigma_{N,t}}   \\ \notag
		\sigma_{i,t}^2 &= \gamma_i+\kappa_{i,t}  v_{i, t-1}^2 +\eta_i  \sigma_{i, t-1}^2, \quad \forall i \\ \notag
		R_{t, i, j} &= {diag(Q_{t, i, j}}^{-1}) . Q_{t, i, j} . diag(Q_{t, i, j}^{-1})  \\ \notag
		Q_{t, i, j} &= (1-\alpha-\beta)  \bar{Q} + \alpha  z_t  z_t'  + \beta  Q_{t, i, j} \notag
\end{align}

Note that above we've aligned the equations by the equal signs. I also want only one tag, and I create spaces using ``quads''.

See if you can figure out how to do complex math using the two examples provided.

<!-- $$ -->
<!-- This is a commented out section in the writing part. -->
<!-- Comments are created by highlighting text, amnd pressing CTL+C -->
<!-- \\begin{align} -->
<!-- \\beta = \\alpha^2 -->
<!-- \end{align} -->
<!-- $$ -->

## Results {-}

Tables can be included as follows. Use the _xtable_ (or kable) package for tables. Table placement = H implies Latex tries to place the table Here, and not on a new page (there are, however, very many ways to skin this cat. Luckily there are many forums online!).


``` r
library(knitr)
library(kableExtra)

data <- mtcars[1:5,] %>% tibble::as_tibble()

table <- kable(data, row.names = TRUE,
      caption = 'Table with kable() and kablestyling()',
      format = "html", booktabs = T) %>%
        kable_styling(full_width = T,
                      latex_options = c("striped",
                                        "scale_down",
                                        "HOLD_position"),
                      font_size = 13)
table
```

<table class="table" style="font-size: 13px; color: black; margin-left: auto; margin-right: auto;">
<caption style="font-size: initial !important;">(\#tab:table-1)Table with kable() and kablestyling()</caption>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> mpg </th>
   <th style="text-align:right;"> cyl </th>
   <th style="text-align:right;"> disp </th>
   <th style="text-align:right;"> hp </th>
   <th style="text-align:right;"> drat </th>
   <th style="text-align:right;"> wt </th>
   <th style="text-align:right;"> qsec </th>
   <th style="text-align:right;"> vs </th>
   <th style="text-align:right;"> am </th>
   <th style="text-align:right;"> gear </th>
   <th style="text-align:right;"> carb </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:right;"> 21.0 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 160 </td>
   <td style="text-align:right;"> 110 </td>
   <td style="text-align:right;"> 3.90 </td>
   <td style="text-align:right;"> 2.620 </td>
   <td style="text-align:right;"> 16.46 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 4 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:right;"> 21.0 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 160 </td>
   <td style="text-align:right;"> 110 </td>
   <td style="text-align:right;"> 3.90 </td>
   <td style="text-align:right;"> 2.875 </td>
   <td style="text-align:right;"> 17.02 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 4 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:right;"> 22.8 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 108 </td>
   <td style="text-align:right;"> 93 </td>
   <td style="text-align:right;"> 3.85 </td>
   <td style="text-align:right;"> 2.320 </td>
   <td style="text-align:right;"> 18.61 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:right;"> 21.4 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 258 </td>
   <td style="text-align:right;"> 110 </td>
   <td style="text-align:right;"> 3.08 </td>
   <td style="text-align:right;"> 3.215 </td>
   <td style="text-align:right;"> 19.44 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:right;"> 18.7 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 360 </td>
   <td style="text-align:right;"> 175 </td>
   <td style="text-align:right;"> 3.15 </td>
   <td style="text-align:right;"> 3.440 </td>
   <td style="text-align:right;"> 17.02 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
</tbody>
</table>

To reference calculations __in text__, _do this:_ From table \@ref(tab:table-1) we see the average value of mpg is 20.98. Notice the use of table-2 in the chunk name. That's the good stuff.

\newpage


# Model summary


Check [this](https://vincentarelbundock.github.io/modelsummary/articles/modelsummary.html) link out for more. Note this package also plays nicely with gt, kableExtra, etc.


```{=html}
<div id="zevbwkfzmz" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#zevbwkfzmz table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#zevbwkfzmz thead, #zevbwkfzmz tbody, #zevbwkfzmz tfoot, #zevbwkfzmz tr, #zevbwkfzmz td, #zevbwkfzmz th {
  border-style: none;
}

#zevbwkfzmz p {
  margin: 0;
  padding: 0;
}

#zevbwkfzmz .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 60%;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: 60%;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#zevbwkfzmz .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#zevbwkfzmz .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#zevbwkfzmz .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#zevbwkfzmz .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#zevbwkfzmz .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#zevbwkfzmz .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#zevbwkfzmz .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#zevbwkfzmz .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#zevbwkfzmz .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#zevbwkfzmz .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#zevbwkfzmz .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#zevbwkfzmz .gt_spanner_row {
  border-bottom-style: hidden;
}

#zevbwkfzmz .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#zevbwkfzmz .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#zevbwkfzmz .gt_from_md > :first-child {
  margin-top: 0;
}

#zevbwkfzmz .gt_from_md > :last-child {
  margin-bottom: 0;
}

#zevbwkfzmz .gt_row {
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#zevbwkfzmz .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#zevbwkfzmz .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#zevbwkfzmz .gt_row_group_first td {
  border-top-width: 2px;
}

#zevbwkfzmz .gt_row_group_first th {
  border-top-width: 2px;
}

#zevbwkfzmz .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#zevbwkfzmz .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#zevbwkfzmz .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#zevbwkfzmz .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#zevbwkfzmz .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#zevbwkfzmz .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#zevbwkfzmz .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}

#zevbwkfzmz .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#zevbwkfzmz .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#zevbwkfzmz .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#zevbwkfzmz .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#zevbwkfzmz .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#zevbwkfzmz .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#zevbwkfzmz .gt_left {
  text-align: left;
}

#zevbwkfzmz .gt_center {
  text-align: center;
}

#zevbwkfzmz .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#zevbwkfzmz .gt_font_normal {
  font-weight: normal;
}

#zevbwkfzmz .gt_font_bold {
  font-weight: bold;
}

#zevbwkfzmz .gt_font_italic {
  font-style: italic;
}

#zevbwkfzmz .gt_super {
  font-size: 65%;
}

#zevbwkfzmz .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#zevbwkfzmz .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#zevbwkfzmz .gt_indent_1 {
  text-indent: 5px;
}

#zevbwkfzmz .gt_indent_2 {
  text-indent: 10px;
}

#zevbwkfzmz .gt_indent_3 {
  text-indent: 15px;
}

#zevbwkfzmz .gt_indent_4 {
  text-indent: 20px;
}

#zevbwkfzmz .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    <tr class="gt_col_headings gt_spanner_row">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="2" colspan="1" scope="col" id=" "> </th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="2" colspan="1" scope="col" id="Unique">Unique</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="2" colspan="1" scope="col" id="Missing Pct.">Missing Pct.</th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="Statistics">
        <span class="gt_column_spanner">Statistics</span>
      </th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="2" colspan="1" scope="col" id="Min">Min</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="2" colspan="1" scope="col" id="Median">Median</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="2" colspan="1" scope="col" id="Max">Max</th>
    </tr>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="Mean">Mean</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="SD">SD</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers=" " class="gt_row gt_left">Fertility</td>
<td headers="Unique" class="gt_row gt_left">46</td>
<td headers="Missing Pct." class="gt_row gt_left">0</td>
<td headers="Mean" class="gt_row gt_left">70.1</td>
<td headers="SD" class="gt_row gt_left">12.5</td>
<td headers="Min" class="gt_row gt_left">35.0</td>
<td headers="Median" class="gt_row gt_left">70.4</td>
<td headers="Max" class="gt_row gt_left">92.5</td></tr>
    <tr><td headers=" " class="gt_row gt_left">Agriculture</td>
<td headers="Unique" class="gt_row gt_left">47</td>
<td headers="Missing Pct." class="gt_row gt_left">0</td>
<td headers="Mean" class="gt_row gt_left">50.7</td>
<td headers="SD" class="gt_row gt_left">22.7</td>
<td headers="Min" class="gt_row gt_left">1.2</td>
<td headers="Median" class="gt_row gt_left">54.1</td>
<td headers="Max" class="gt_row gt_left">89.7</td></tr>
    <tr><td headers=" " class="gt_row gt_left">Examination<span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;"><sup>1</sup></span></td>
<td headers="Unique" class="gt_row gt_left">22</td>
<td headers="Missing Pct." class="gt_row gt_left">0</td>
<td headers="Mean" class="gt_row gt_left">16.5</td>
<td headers="SD" class="gt_row gt_left">8.0</td>
<td headers="Min" class="gt_row gt_left">3.0</td>
<td headers="Median" class="gt_row gt_left">16.0</td>
<td headers="Max" class="gt_row gt_left">37.0</td></tr>
    <tr><td headers=" " class="gt_row gt_left">Education</td>
<td headers="Unique" class="gt_row gt_left">19</td>
<td headers="Missing Pct." class="gt_row gt_left">0</td>
<td headers="Mean" class="gt_row gt_left">11.0</td>
<td headers="SD" class="gt_row gt_left">9.6</td>
<td headers="Min" class="gt_row gt_left">1.0</td>
<td headers="Median" class="gt_row gt_left">8.0</td>
<td headers="Max" class="gt_row gt_left">53.0</td></tr>
    <tr><td headers=" " class="gt_row gt_left">Catholic</td>
<td headers="Unique" class="gt_row gt_left">46</td>
<td headers="Missing Pct." class="gt_row gt_left">0</td>
<td headers="Mean" class="gt_row gt_left">41.1</td>
<td headers="SD" class="gt_row gt_left">41.7</td>
<td headers="Min" class="gt_row gt_left">2.1</td>
<td headers="Median" class="gt_row gt_left">15.1</td>
<td headers="Max" class="gt_row gt_left">100.0</td></tr>
    <tr><td headers=" " class="gt_row gt_left">Infant.Mortality</td>
<td headers="Unique" class="gt_row gt_left">37</td>
<td headers="Missing Pct." class="gt_row gt_left">0</td>
<td headers="Mean" class="gt_row gt_left">19.9</td>
<td headers="SD" class="gt_row gt_left">2.9</td>
<td headers="Min" class="gt_row gt_left">10.8</td>
<td headers="Median" class="gt_row gt_left">20.0</td>
<td headers="Max" class="gt_row gt_left">26.6</td></tr>
  </tbody>
  
  <tfoot class="gt_footnotes">
    <tr>
      <td class="gt_footnote" colspan="8"><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;"><sup>1</sup></span> A very <strong>important</strong> Footnote.</td>
    </tr>
  </tfoot>
</table>
</div>
```


# References {-}

<div id="refs"></div>


# Appendix {-}

## Appendix A {-}

Some appendix information here

## Appendix B {-}



