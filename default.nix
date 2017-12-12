{ pkgs ? (import <nixpkgs> {}), stdenv ? pkgs.stdenv, texlive ? pkgs.texlive, biber ? pkgs.biber }:

let
  tex = texlive.combine { 
    inherit (texlive) 
    scheme-small 
    collection-bibtexextra
    bibtex biblatex 
    latexmk;
  };
  filename = "paper";
in
stdenv.mkDerivation {
  name = "change-structures";
  buildInputs = [ tex biber ];
  src = ./.;
  buildPhase = "latexmk -view=pdf ${filename}";
  installPhase = "install -Dt $out ${filename}.pdf";
}
