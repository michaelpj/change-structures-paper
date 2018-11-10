{
  pkgs ? (import <nixpkgs> {}),
  stdenv ? pkgs.stdenv,
  texlive ? pkgs.texlive,
  biber ? pkgs.biber,
  ghostscript ? pkgs.ghostscript
}:

let
  tex = texlive.combine {
    inherit (texlive)
    scheme-small
    collection-bibtexextra
    collection-latex
    collection-latexextra
    collection-luatex
    collection-fontsextra
    collection-fontsrecommended
    collection-mathscience
    acmart
    bibtex biblatex
    latexmk;
  };
in
stdenv.mkDerivation {
  name = "change-structures";
  buildInputs = [ tex biber ghostscript ];
  src = pkgs.lib.sourceFilesBySuffices ./. [ ".tex" ".bib" ".cls" ".bst" ];
  buildPhase = "latexmk -view=pdf change-structures";
  installPhase = "install -Dt $out *.pdf";
}
