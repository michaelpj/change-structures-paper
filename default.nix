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
    collection-luatex
    collection-mathextra
    bibtex biblatex 
    latexmk;
  };
  filename = "paper";
in
stdenv.mkDerivation {
  name = "change-structures";
  buildInputs = [ tex biber ghostscript ];
  src = ./.;
  buildPhase = "latexmk -view=pdf ${filename}";
  installPhase = "install -Dt $out ${filename}.pdf";
}
