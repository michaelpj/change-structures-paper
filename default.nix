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
    #collection-mathextra
    acmart
    bibtex biblatex 
    latexmk;
  };
in
stdenv.mkDerivation {
  name = "change-structures";
  buildInputs = [ tex biber ghostscript ];
  src = ./.;
  buildPhase = ''
    latexmk -view=pdf change-structures datalog
  '';
  installPhase = "install -Dt $out *.pdf";
}
