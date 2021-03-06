% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/antsRegistration.R
\name{antsRegistration}
\alias{antsRegistration}
\title{Perform registration between two images.}
\usage{
antsRegistration(fixed = NA, moving = NA, typeofTransform = "SyN",
  initialTransform = NA, outprefix = "", mask = NA, gradStep = NA,
  verbose = FALSE, ...)
}
\arguments{
\item{fixed}{fixed image to which we register the moving image.}

\item{moving}{moving image to be mapped to fixed space.}

\item{typeofTransform}{A linear or non-linear registration type.  Mutual
information metric by default. See \code{Details.}}

\item{initialTransform}{transforms to prepend}

\item{outprefix}{output will be named with this prefix.}

\item{mask}{mask the registration.}

\item{gradStep}{gradient step size (not for all tx)}

\item{verbose}{request verbose output (useful for debugging)}

\item{...}{additional options see antsRegistration in ANTs}
}
\value{
outputs a list containing:
\itemize{
  \item{warpedmovout: }{Moving image warped to space of fixed image.}
  \item{warpedfixout: }{Fixed image warped to space of moving image.}
  \item{fwdtransforms: }{Transforms to move from moving to fixed image.}
  \item{invtransforms: }{Transforms to move from fixed to moving image.}
}
Ouptut of 1 indicates failure
}
\description{
Register a pair of images either through the full or simplified interface
to the ANTs registration method.
}
\details{
typeofTransform can be one of:
\itemize{
  \item{"Translation": }{Translation transformation.}
  \item{"Rigid": }{Rigid transformation: Only rotation and translation.}
  \item{"QuickRigid": }{Rigid transformation: Only rotation and translation.
  May be useful for quick visualization fixes.'}
  \item{"BOLDRigid": }{Rigid transformation: Parameters typical for BOLD
  to BOLD intrasubject registration'.'}
  \item{"Affine": }{Affine transformation: Rigid + scaling.}
  \item{"AffineFast": }{Fast version of \code{Affine}.}
  \item{"BOLDAffine": }{Affine transformation: Parameters typical for BOLD
  to BOLD intrasubject registration'.'}
  \item{"ElasticSyN": }{Symmetric normalization: Affine + deformable transformation,
    with mutual information as optimization metric and elastic regularization.}
  \item{"SyN": }{Symmetric normalization: Affine + deformable transformation,
    with mutual information as optimization metric.}
  \item{"SyNRA": }{Symmetric normalization: Rigid + Affine + deformable transformation,
    with mutual information as optimization metric.}
  \item{"SyNOnly": }{Symmetric normalization: no initial transformation,
    with mutual information as optimization metric.  Assumes images are
    aligned by an inital transformation. Can be useful if you want to run
    an unmasked affine followed by masked deformable registration.}
  \item{"SyNCC": }{SyN, but with cross-correlation as the metric.}
  \item{"SyNBold": }{SyN, but optimized for registrations between
    BOLD and T1 images.}
  \item{"SyNBoldAff": }{SyN, but optimized for registrations between
    BOLD and T1 images, with additional affine step.}
  \item{"SyNAggro": }{SyN, but with more aggressive registration
    (fine-scale matching and more deformation).  Takes more time than \code{SyN}.}
  \item{"TVMSQ": }{time-varying diffeomorphism with mean square metric}
}
}
\examples{

fi <- antsImageRead(getANTsRData("r16") ,2)
mi <- antsImageRead(getANTsRData("r64") ,2)
fi<-resampleImage(fi,c(60,60),1,0)
mi<-resampleImage(mi,c(60,60),1,0) # speed up
mytx <- antsRegistration(fixed=fi, moving=mi, typeofTransform = c('SyN') )
mywarpedimage <- antsApplyTransforms( fixed=fi, moving=mi,
  transformlist=mytx$fwdtransforms )

\dontrun{ # quick visualization fix for images with odd orientation
mni = antsImageRead( getANTsRData( "mni" ) )
strokt1=antsImageRead('strokt1.nii.gz')
strokt1reg=antsRegistration(
  fixed=mni,
  moving=strokt1,
  typeofTransform = "QuickRigid",verbose=TRUE )
 plot(  strokt1reg$warpedmovout, axis=3, nslices=20)
}

}
\author{
Shrinidhi KL, Tustison NJ, Avants BB
}

