package HTML::Lint::Pluggable::HTML5;
use 5.008_001;
use strict;
use warnings;

our $VERSION = '0.04';

use parent qw/ HTML::Lint::Pluggable::WhiteList /;
use List::MoreUtils qw/any/;

my %html5_tag = map { $_ => 1 } qw/article aside audio canvas command datalist details embed figcaption figure footer header hgroup keygen mark menu meter nav output progress section source summary time video rp rt ruby wbr/;

my %html5_global_attr = map { $_ => 1 } qw/contenteditable contextmenu draggable dropzone hidden role spellcheck tabindex translate/;
my @html5_global_user_attr = (qr/^aria-/, qr/^data-/);
my %html5_attr = (
    a        => +{ map { $_ => 1 } qw/media/ },
    area     => +{ map { $_ => 1 } qw/media hreflang rel/ },
    base     => +{ map { $_ => 1 } qw/target/ },
    meta     => +{ map { $_ => 1 } qw/charset/ },
    input    => +{ map { $_ => 1 } qw/autofocus placeholder form required autocomplete min max multiple pattern step dirname formaction formenctype formmethod formnovalidate formtarget/ },
    select   => +{ map { $_ => 1 } qw/autofocus form required/ },
    textarea => +{ map { $_ => 1 } qw/autofocus placeholder form required dirname maxlength wrap/ },
    button   => +{ map { $_ => 1 } qw/form autofocus formaction formenctype formmethod formnovalidate formtarget/ },
    output   => +{ map { $_ => 1 } qw/form/ },
    label    => +{ map { $_ => 1 } qw/form/ },
    object   => +{ map { $_ => 1 } qw/form/ },
    fieldset => +{ map { $_ => 1 } qw/form disabled/ },
    form     => +{ map { $_ => 1 } qw/novalidate/ },
    menu     => +{ map { $_ => 1 } qw/type label/ },
    style    => +{ map { $_ => 1 } qw/scoped/ },
    script   => +{ map { $_ => 1 } qw/async/ },
    html     => +{ map { $_ => 1 } qw/manifest/ },
    link     => +{ map { $_ => 1 } qw/sizes/ },
    ol       => +{ map { $_ => 1 } qw/reversed/ },
    iframe   => +{ map { $_ => 1 } qw/sandbox seamless srcdoc allowfullscreen/ },
);

# Generated by html5_entities.pl
my %html5_entity = map { "&" . $_ . ";" => 1 } qw/ efDot ocir cir lBarr eqcolon
    period ddotseq vcy nsube origof boxVr nleqq Uogon nGg boxvl LeftUpVectorBar
    lbrke prE ngsim ContourIntegral bepsi Kcy nvrArr Lacute prec incare Qfr gsim
    eDDot lsquor rdsh ENG rightarrow rcedil rdldhar REG pcy gneqq nparsl
    angmsdag rAtail DoubleLeftArrow dot Uarr Bscr eg QUOT tcy topbot supsetneqq
    gtdot trie nexist div circeq downarrow RBarr SquareSuperset bottom frown
    lcub nwarhk NotNestedGreaterGreater scE mscr IJlig equals DownLeftTeeVector
    gcy Darr Therefore tfr precnsim supsetneq frac58 tcaron sol lvertneqq
    VeryThinSpace dotminus nle langd ocy gE KHcy parsim bkarow urcrop ohm
    ClockwiseContourIntegral Bumpeq vsubne lopf oast angmsdad risingdotseq sopf
    lesdoto Colone plussim GJcy nlArr ominus hardcy gfr cacute uharr OverBar
    lesg nprec Zacute vDash UpEquilibrium LongLeftArrow Sacute supnE
    LeftUpVector subsup NotSquareSupersetEqual NotTildeTilde frac35 YIcy iecy
    Kopf backprime siml nsqsube multimap thetav searhk Eopf RightArrowLeftArrow
    becaus mumap laemptyv dfisht copysr DiacriticalGrave Gt nsupset MediumSpace
    scsim sqsube nisd supseteq hoarr xcup scap vBarv geq Laplacetrf Implies
    vsubnE sfr Rcy blacktriangleright ngeqslant ZHcy numero dd bnequiv smashp
    DotDot DoubleDot blank boxminus Sum rtrie Uopf Subset cirmid nvsim eparsl
    CircleMinus angzarr ncong csupe odash par Tcy xuplus LessSlantEqual lap
    bumpE LessGreater RightDownTeeVector cemptyv ffr plustwo Hscr rbrack ltrPar
    lmidot ldquor curlyeqprec supne longmapsto Re Map caret NotEqualTilde NJcy
    nrarr NotCongruent squarf Cup Rcaron NotGreaterSlantEqual nLt leftarrowtail
    olcross ecolon Itilde npart uhblk DD SupersetEqual Iogon NotTildeEqual YUcy
    pertenk Wcirc VerticalTilde RightArrowBar kfr commat Supset veeeq leftarrow
    ltimes planck scy mlcp Ufr trpezium rtrif epsiv boxvh boxvR bigcup
    UpperRightArrow ltdot vdash lltri thicksim gdot And GreaterSlantEqual npre
    shcy lnsim fflig esim rangd qprime solb dzigrarr lsh mapstodown apid Tcaron
    Tfr tstrok ascr andd subedot boxHd NotLessTilde strns jopf Precedes UnderBar
    NonBreakingSpace it napos sstarf PrecedesTilde Cacute lfisht triangledown
    midcir iiint roplus bemptyv sqcup slarr sqcups rtimes yscr filig upsi CupCap
    Sub between ycy Ucy colon npar bigcirc boxvr duhar xvee wfr NotVerticalBar
    backsimeq nparallel Breve nless ApplyFunction DoubleContourIntegral rarrpl
    Vbar tritime boxur Bernoullis lcy frac45 SucceedsSlantEqual scpolint
    GreaterGreater LeftCeiling succnsim nedot CircleDot nrtri NotLessEqual
    blacklozenge dcy nsimeq half triangleq rmoustache jukcy Sopf dbkarow odblac
    Nopf clubsuit rightharpoonup OverBracket phone DownTee RightTriangle
    NotSupersetEqual spadesuit LessEqualGreater ropf lessgtr cups sce awint
    bumpeq ntriangleright Icy pitchfork nrtrie bigtriangledown boxul ufr ucy
    uogon erDot OpenCurlyQuote succcurlyeq NotSquareSuperset larrtl nvHarr AMP
    Or nacute nleqslant lhblk lpar simg xrArr icy nvDash Congruent Backslash
    TRADE fscr intcal REG Vcy rightrightarrows llarr trianglelefteq rarrb
    triminus nleftrightarrow LJcy subseteq leftrightharpoons utrif qfr boxuR
    hybull looparrowleft lgE rbrksld capcup nsupe nbumpe frac56 boxDl GT UpArrow
    boxhd hksearow twoheadrightarrow RightUpTeeVector uparrow DoubleRightArrow
    tint GreaterEqual nsupseteq LT Equilibrium LongRightArrow LeftVectorBar
    NotTilde boxtimes TSHcy UpperLeftArrow bigstar SHcy COPY gtrapprox Dopf
    models xodot Kcedil kcedil angmsdaa ratio NotLess vellip Colon vBar supE
    RightAngleBracket cirscir timesbar Ll blacktriangleleft telrec nvlArr parsl
    rarrlp NotEqual ll nRightarrow quest lozenge lbbrk andv easter ast
    curlywedge nvap uharl notinvc gbreve Vee nlarr nwarr expectation
    GreaterEqualLess ell lbarr supdot cupdot kappav Lopf circledS
    NotGreaterEqual boxHu gne boxhD lrtri eqslantgtr niv Copf Succeeds
    bigtriangleup tshcy RightTeeArrow SOFTcy Ncy UpTeeArrow kopf lharu nVdash
    nearr DoubleUpArrow imof urcorn nge hairsp hercon dotplus gtcir oint lscr
    boxUl NotSucceedsTilde angmsdac blacksquare rhov olarr NotGreaterFullEqual
    ecaron DownArrowBar frac15 HumpEqual naturals llhard nsupE raemptyv Bopf
    rpargt nvge ofr Lfr larrlp lsqb nprcue checkmark srarr jmath boxUR
    leftharpoondown Hfr SHCHcy circleddash osol Ifr uuarr preccurlyeq NoBreak
    upharpoonleft Jscr UnderBrace smeparsl harrcir leftleftarrows
    DoubleLongLeftRightArrow simlE Cross geqq ii DoubleLeftTee Longrightarrow
    angle xotime af ulcorn Lt angst blk14 Barv RightTeeVector Oopf varr
    OverParenthesis vangrt ogon gsime varpi smte prnsim esdot amalg
    LeftAngleBracket zscr subdot NotLessSlantEqual gtlPar smile coprod Dot
    colone Gdot omacr iscr rmoust lesdot les smtes Rightarrow iopf
    NotGreaterGreater mnplus ffilig operp ImaginaryI lthree Product Vdashl tscy
    succsim ijlig triangleleft sc hkswarow Upsi breve equest Scedil aopf
    doteqdot wreath Mfr drcrop rHar Yscr Umacr Ocy bcong supmult num Fscr
    circlearrowright eqsim lstrok order dblac nap lowbar roarr uopf diam diamond
    NotHumpDownHump ccaron lessapprox notinvb CircleTimes twixt nis
    NotLeftTriangle approxeq Vdash gnapprox subseteqq cwint Ecy lfr blk34
    CounterClockwiseContourIntegral loang dharr dtri gtquest eDot geqslant disin
    Otimes LessLess gel leftrightarrows Cfr nvrtrie beth NotRightTriangleBar
    barwedge smid Sfr COPY napid map ropar wedge ntgl boxhU smt Ropf
    smallsetminus lesdotor ssetmn DownArrowUpArrow LeftTee imagline squ lagran
    Uring Gg nscr boxv Gcy Zcaron apE DoubleDownArrow leq zcaron Tscr DotEqual
    rbrace rcy NotGreaterLess hopf lesssim Zopf lcedil Lscr vArr
    UnderParenthesis cross numsp asympeq csub Zcy plusb bsolb gesles iff nvgt
    Intersection Xopf lmoust itilde boxdl CHcy roang Bfr lacute Cedilla
    nshortmid wscr larrfs lmoustache plankv nsucceq Afr lE varsupsetneqq pfr
    curlyeqsucc odiv PrecedesEqual Pr phiv mcomma kjcy blacktriangledown prcue
    rbbrk Vert drcorn Downarrow Dfr gesl gtrdot Tab starf Rarr Mcy xwedge Kscr
    sigmav OverBrace exponentiale Pfr vltri amacr cuepr gvnE lEg cdot el subrarr
    nsubseteq rarrsim Oscr nequiv simeq quatint umacr dfr subnE boxbox udarr
    Tilde Ccirc heartsuit efr Cconint xscr comma napprox apacir ulcrop tbrk
    LeftUpDownVector boxDR escr nrarrw rightsquigarrow RightFloor Vscr shchcy
    angmsdah ThickSpace NotSuperset dcaron ngE gesdot flat neArr eopf
    DownRightVector Wscr Wfr SucceedsTilde measuredangle Equal uwangle
    NotPrecedes vartheta tscr female ExponentialE lesseqqgtr lne Fouriertrf
    bigwedge zopf jscr DiacriticalTilde rsquor ReverseElement bigoplus
    CapitalDifferentialD cupcup capand LeftArrow iiiint imath Tstrok blk12 copf
    Xfr rect emptyset DiacriticalDoubleAcute ffllig triangle lneqq ohbar mho oS
    sext Ofr dollar acE FilledSmallSquare rfisht pre Int zfr bbrktbrk rotimes
    vzigzag upharpoonright ges nleftarrow bbrk nLeftarrow Rrightarrow Gcedil
    Eogon Iukcy nesear IEcy SquareSupersetEqual UpArrowDownArrow vrtri realpart
    zeetrf acd Esim Ycy NotLessGreater lsim lharul curvearrowleft uring precneqq
    nLtv cudarrr urcorner rpar gla RightUpVector propto nsccue ccupssm verbar
    realine xharr emptyv subsetneq caron LessTilde lnapprox sqcaps cirfnint
    nhpar napE Wopf LeftTeeVector Dcy lopar Yfr suplarr isinE nges nsubset
    rightleftarrows NotLeftTriangleBar Bcy puncsp thksim tdot lvnE
    LeftDownVectorBar boxvL circlearrowleft prurel lobrk popf excl qint nles
    succapprox gsiml iogon boxHD dstrok equivDD ShortLeftArrow bullet subne
    andslope ngt DDotrahd NewLine olt range supset vsupne EqualTilde pm xnis
    bNot emsp13 vnsub xdtri caps precsim Rscr rarrbfs HilbertSpace subplus Qscr
    bcy hfr SquareIntersection npolint rightharpoondown fltns Ccaron angrt
    ssmile nsup UnionPlus ccirc dtdot nGtv fcy nvle lnE rbrke profline
    upuparrows zhcy Mopf ratail thickapprox Abreve cupbrcap dscy Square udblac
    Cdot dash preceq DoubleRightTee downharpoonleft imacr frac23 iiota Aogon
    leqslant NotRightTriangleEqual jsercy intprod Zfr straightphi
    DiacriticalAcute isindot ngeqq Lleftarrow YAcy xcap aleph gtrarr Dashv
    RuleDelayed epar ReverseUpEquilibrium twoheadleftarrow angrtvbd ultri Im
    star boxvH lbrksld in VerticalLine boxhu hscr prsim vnsup RightArrow VDash
    Nacute LeftDownTeeVector boxdr VerticalSeparator eqslantless Dscr uplus
    fpartint succeq male lozf lrhar dopf SquareSubsetEqual ldca LeftUpTeeVector
    vopf ring Ubreve DownLeftVectorBar Omacr yacy angsph backsim ddarr parallel
    yfr updownarrow lrcorner notinE nsim xmap nearrow subsim Zscr langle
    diamondsuit ncaron larrsim ntriangleleft topfork RoundImplies ShortDownArrow
    ofcir glj NegativeThickSpace lbrkslu Assign DownLeftRightVector mDDot divonx
    Iscr questeq lates nltrie ap sqsub rrarr Uscr NotHumpEqual angmsdab notni
    nsupseteqq angmsdae phmmat rBarr Escr lat RightVector Rarrtl Pscr ord robrk
    elinters Xscr cscr NotSquareSubsetEqual LeftTeeArrow sqsubseteq mstpos nbump
    nwnear nvinfin longleftrightarrow Jfr nspar leftrightarrow gneq scirc
    NestedGreaterGreater bsol boxVH varsupsetneq rbrkslu xutri because boxh
    nrArr RightDownVector nrightarrow rtriltri minusb doublebarwedge lrhard
    erarr gesdoto InvisibleComma rx rhard gesdotol isinsv percnt SucceedsEqual
    ovbar kscr simdot bot Acy gnE ggg Idot boxUL Utilde larrb LeftTriangleBar
    Iopf CloseCurlyDoubleQuote KJcy ngtr kgreen nsqsupe LeftVector ddagger
    hyphen nvdash ShortUpArrow Verbar boxV llcorner NotSquareSubset integers
    rharul longrightarrow ycirc bnot PartialD rharu gescc bigvee rbarr succneqq
    NotSucceeds fork Wedge hcirc shortmid dlcrop bopf tridot Hat Gammad
    downdownarrows InvisibleTimes angmsd bsolhsub imagpart Leftrightarrow rarrhk
    rthree utri CloseCurlyQuote bprime gtrsim CenterDot lhard UnderBracket
    Uarrocir curlyvee rAarr rarrap Vvdash tprime imped boxDL barvee fllig
    CirclePlus circledcirc Efr Cscr jfr Mellintrf NegativeThinSpace
    Poincareplane daleth NotExists NotTildeFullEqual odsold TScy notinva Yopf
    orderof nrarrc xrarr Imacr Longleftrightarrow Rcedil DScy duarr yucy doteq
    notniva reals lAtail curarrm Sup bsime Emacr GT OpenCurlyDoubleQuote Tcedil
    rfr orslope SmallCircle Sc lesges lurdshar lHar sqsubset frac38 precnapprox
    die circledR gtreqless Ascr precapprox NotNestedLessLess Conint
    DownRightTeeVector xfr DownLeftVector congdot subsetneqq urtri lneq njcy
    sime gg frac13 SuchThat Lcedil varsubsetneq Sscr backcong NotSubsetEqual
    inodot NegativeVeryThinSpace cuesc lrarr ange ncedil dharl andand Lcaron
    Longleftarrow xcirc angrtvb leqq Pcy homtht Gcirc Star succnapprox midast
    chcy HumpDownHump olcir bump ic dashv toea Scy ljcy ngeq notnivc
    leftthreetimes ReverseEquilibrium bigotimes Lstrok squf gtcc plusdo gEl
    LeftTriangle sqsupseteq latail Coproduct ubrcy nsucc emacr rationals Popf
    NestedLessLess loarr dlcorn nLl plusacir odot zdot boxVh boxplus complement
    UpDownArrow sfrown sung bscr Sqrt Scirc downharpoonright isins csup
    TripleDot Rsh ldrushar cylcty eplus tcedil LeftTriangleEqual gimel
    NegativeMediumSpace cfr target ctdot demptyv Racute qscr eng sacute
    looparrowright NotSucceedsSlantEqual rarrtl conint Dstrok mp Gopf Jukcy
    rarrw profalar UpArrowBar GreaterTilde rightleftharpoons softcy
    TildeFullEqual simrarr pr solbar straightepsilon boxDr lparlt nwarrow
    GreaterLess Del notindot supedot tosa Nscr NotSucceedsEqual gnsim ForAll
    NotElement Gscr nGt Ncedil sqcap frac18 rppolint lessdot
    NotPrecedesSlantEqual hookrightarrow yicy supsup minusd simne ncap supsub
    Because rarrfs top rcaron Not lotimes shortparallel oror gl nlE square
    zigrarr gopf cwconint bowtie frac25 late curvearrowright frac78 setminus
    DifferentialD epsi simgE edot swnwar nmid bigcap varsigma varepsilon hbar
    gap boxdL rscr rsqb triangleright qopf loplus RightTee ldrdhar varkappa
    grave orarr vscr ccups awconint supdsub UpTee sharp ecir Lang ntlg
    leftharpoonup Hstrok Ycirc ccaps ncy xhArr gcirc bsim fopf boxH nsc
    LeftDownVector simplus els emsp14 DiacriticalDot cupcap scedil therefore
    cudarrl bumpe DoubleLongLeftArrow rightarrowtail succ sccue gvertneqq
    nvltrie Rfr RightCeiling Aopf nVDash subset nang sdote vartriangleleft
    RightTriangleBar trianglerighteq hslash planckh ecy cupor PrecedesSlantEqual
    horbar VerticalBar varphi notnivb Nfr ThinSpace Fopf biguplus lcaron compfn
    race intlarhk wopf boxVl lsimg LongLeftRightArrow ncup bigodot swArr QUOT
    searrow nLeftrightarrow Vfr AMP HorizontalLine DownTeeArrow hamilt eqcirc
    Edot LowerLeftArrow sdotb wedbar rtri leftrightsquigarrow egsdot ac Exists
    NotCupCap comp ntrianglelefteq NotGreaterTilde supseteqq mcy nfr Gfr ubreve
    coloneq backepsilon supsim dzcy Element intercal nharr nltri NotLessLess
    lesseqgtr DoubleLongRightArrow ltlarr veebar Fcy DownRightVectorBar isinv
    afr nvlt LessFullEqual boxVR Lcy blacktriangle DJcy bigsqcup harrw ltrie
    HARDcy larrpl xoplus SubsetEqual Cap ldsh mid aogon Ubrcy dHar sqsupe xlArr
    abreve omid rnmid vprop gtreqqless ruluhar Ecaron yopf drbkarow complexes
    seswar DownBreve rlhar forkv zacute Leftarrow gacute mapsto Superset
    DoubleVerticalBar fallingdotseq NotRightTriangle wcirc swarrow minusdu thkap
    scnsim capbrcup timesb Qopf utilde longleftarrow Mscr Integral prnap Hcirc
    triplus kcy swarr RightVectorBar djcy dtrif natur Diamond centerdot approx
    rarrc ltcir lsime DownArrow ntrianglerighteq curarr bne LowerRightArrow
    nsmid lbrack dotsquare spar gjcy IOcy pluse oopf suphsol primes barwed
    angmsdaf nsce Rang rdca ltrif scnE RightDownVectorBar iinfin ee sqsupset ape
    plusdu EmptySmallSquare trisb eqvparsl RightUpDownVector natural gnap
    ltquest MinusPlus DZcy nshortparallel ZeroWidthSpace varpropto nhArr
    vartriangleright bfr npreceq topcir Ffr Hopf leg rsh cularrp ogt Dcaron nopf
    opar boxUr LeftArrowRightArrow cuvee varrho suphsub RightTriangleEqual
    Updownarrow ufisht boxVL rdquor Barwed Cayleys uscr LeftRightArrow cularr
    cuwed boxuL varnothing nlsim LeftDoubleBracket jcy Kfr malt NotSubset iukcy
    RightDoubleBracket xopf timesd cirE subE sscr mapstoleft Odblac lg rlarr
    LeftFloor frac16 mldr circledast LT jcirc NotGreater plus quaternions
    otimesas ulcorner mopf iprod supplus eogon subsub mfr Vopf nearhk nsime
    elsdot ltri swarhk Hacek ncongdot vfr zcy dwangle uHar Larr oscr seArr
    SquareUnion Ncaron udhar larrbfs Proportion FilledVerySmallSquare PlusMinus
    fjlig Union xlarr boxHU nleq nesim iocy glE dscr check maltese racute capdot
    wp pluscir EmptyVerySmallSquare Jcirc NotPrecedesEqual boxdR LeftArrowBar
    infintie NotDoubleVerticalBar wedgeq larrhk utdot vert dsol SquareSubset
    hookleftarrow NotReverseElement lbrace nlt Zdot Lsh npr pointint Jopf Lmidot
    bernou csube TildeEqual digamma sqsup GreaterFullEqual lAarr rcub gtrless
    gammad RightUpVectorBar Topf gscr bsemi cire ltcc lescc DoubleLeftRightArrow
    Proportional Jsercy orv semi prnE nsubE Uparrow TildeTilde capcap submult
    Jcy egs prap xsqcup NotLeftTriangleEqual wr luruhar nldr rightthreetimes ifr
    LeftRightVector block scnap pscr Amacr varsubsetneqq searr vsupnE topf
    hstrok acy mapstoup marker khcy nwArr nexists setmn Gbreve DoubleUpDownArrow
    Udblac nsubseteqq profsurf divideontimes rangle lnap vee ShortRightArrow/;

sub init {
    my($class, $lint) = @_;
    $class->SUPER::init($lint => +{
        rule => +{
            'elem-unknown' => sub {
                my $param = shift;
                return 1 if $html5_tag{$param->{tag}};
                return 0;
            },
            'attr-unknown' => sub {
                my $param = shift;
                return 1 if $html5_global_attr{$param->{attr}};
                return 1 if $html5_attr{$param->{tag}}{$param->{attr}};
                return 1 if any { $param->{attr} =~ $_ } @html5_global_user_attr;
                return 0;
            },
            'text-unknown-entity' => sub {
                my $param = shift;
                return 1 if $html5_entity{$param->{entity}};
                return 0;
            },
        }
    });
}

1;
__END__

=head1 NAME

HTML::Lint::Pluggable::HTML5 - allow HTML5 tags and attributes.

=head1 VERSION

This document describes HTML::Lint::Pluggable::HTML5 version 0.04.

=head1 DEPENDENCIES

Perl 5.8.1 or later.

=head1 BUGS

All complex software has bugs lurking in it, and this module is no
exception. If you find a bug please either email me, or add the bug
to cpan-RT.

=head1 SEE ALSO

L<perl>

=head1 AUTHOR

Kenta Sato E<lt>karupa@cpan.orgE<gt>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2012, Kenta Sato. All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
