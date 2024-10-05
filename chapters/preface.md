# Preface
## Preface to the First Edition

*Power System Oscillations* deals with the analysis and control of low frequency oscillations in the 0.2--3 Hz range, which are a characteristic of interconnected power systems. Small variations in system load excite the oscillations, which must be damped effectively to maintain secure and stable system operation. No warning is given for the occurrence of growing oscillations caused by oscillatory instability, since a change in the system’s operating condition may cause the transition from stable to unstable. If not limited by nonlinearities, unstable oscillations may lead to rapid system collapse. Thus, it is difficult for operators to intervene manually to restore the system’s stability. It follows that it is important to analyze a system’s oscillatory behavior in order to understand the system’s limits. If the limits imposed by oscillatory instability are too low, they may be increased by the installation of special stabilizing controls.

Since the late '60s when this phenomenon was first observed in the North American systems, intensive research has resulted in design and installation of stabilizing controls known as power system stabilizers (PSSs). The design, location and tuning of PSSs require special analytical tools. This book addresses these questions in a modal analysis framework, with transient simulation as a measure of controlled system performance. After discussing the nature of the oscillations, the design of the PSS is discussed extensively using modal analysis and frequency response. In the scenario of the restructured power system, the performance of power system damping control must be sensitive to parameter uncertainties. Power system stabilizers, when well tuned, are shown to be robust using techniques of modern control theory. The design of damping controls, which operate through electronic power system devices (FACTS), is also discussed. There are many worked examples throughout the text.

The Power System Toolbox for use with MATLAB is used to perform all the analyses used in this book. Simulation results, in the form of MATLAB binary files, and data for all examples, are available to the readers.

The text is based on the author’s experience of over 40 years as an engineer in the power industry and as an educator.

<p style="text-align:left;">
    <span style="float:left;">
        Colborne, Ontario, Canada
    </span>
    <span style="float:right;">
        <i>Graham Rogers</i>
    </span>
</p>
<p style="text-align:right;">
    2000
</p>

## Preface to the Second Edition

In 2000, Graham Rogers published the classic text *Power System Oscillations* which provided detailed discussion of the analysis of complex power system models for the computation and understanding of oscillations encountered in power systems. These oscillations had already been recorded by digital phasor measurement units (PMUs). The text covered power system modeling, linearization to obtain small-signal models, and eigenvalue and eigenvector analysis leading to the notions of local and interarea mode oscillations. In addition, traditional and robust control design methods completed the repertoire for a power system engineer to analyze small-signal stability and design controllers to improve the damping of specific lightly damped oscillatory modes.

In about 2015, in light of rapid developments in power system measurements, Graham asked one of the coauthors (Joe) of this new edition to expand the coverage of the original text to include data-driven methods. At that time, it was felt that some of the tools were still in developmental stages and such an effort might be premature. Subsequently, as more results are becoming available, the co-authors of the second edition started the project in 2023. Two co-authors (Dan and Joe) had worked with Graham, while others are users of the Power System Toolbox. Graham did the lion's share of the work to add new models and datasets to the Power System Toolbox. In addition, we have included newly developed control models of renewable resources for simulation and small-signal stability analysis.

This second edition preserves the first ten chapters as written by Graham. These chapters are now grouped into Parts 1 and 2. Chapters 9 and 10 on robust control are more advanced and comprise Part 2, allowing a reader to skip them on first reading. Parts 1 and 2 have some minor updates. Also the MATLAB files used in the discussion and examples are now completely updated, providing a reader an additional means to understand the analysis and design procedures. The new materials are contained in Part 3, consisting of Chapters 11 to 15.

As mentioned earlier, the new materials consist primarily of data-driven analysis methods and control design. In particular, modal analysis algorithms for both disturbance events and ambient conditions are described. In the same vein as the first edition, we aim at striking a balance between analytical derivations and practical insights. Examples and real measured data are used to illustrate how to deal with real measurements and interpret the results. MATLAB files to execute many examples may be found on the website that accompanies this book. To our readers, we ask you to please drop us a note if you find typos, and more important, tell us how to improve the discussion of our materials.

We would like to acknowledge many individuals who had worked with us and offered their engineering insights to us. John F. Hauer (Bonneville Power Administration and Pacific Northwest National Laboratory) started the use of the Prony method for phasor measurement data analysis. John W. Pierre (University of Wyoming) applied spectral analysis methods to power system ambient data. Dmitry N. Kosterev (BPA) whose phasor data analysis of US Western Interconnection Blackouts raised the importance of phasor data and proper tuning of power system stabilizers. Brian Pierre, David Schoenwald, Ray Byrne, and Jason Neely contributed significantly to the Pacific DC Intertie (PDCI) Damping Controller Project. Philip Overholt had the foresight to commit DOE funding to install phasor measurement units throughout the US power grids. The PDCI project would not have been possible without support from him and his DOE colleague Imre Gyuk. You Wu, an RPI undergraduate student, was instrumental in updating Chapters 1 through 10 with LaTeX, color figures, and MATLAB m-files. We are very much indebted to them. We would also like to acknowledge the National Science Foundation, US Department of Energy, Pacific Northwest National Laboratory, and Sandia National Laboratories for their many years of research support.

<p style="text-align:left;">
    <span style="float:left;">
        Albuquerque, New Mexico
    </span>
    <span style="float:right;">
        <i>Ryan T. Elliott</i>
    </span><br>
    <span style="float:left;">
        Butte, Montana
    </span>
    <span style="float:right;">
        <i>Daniel J. Trudnowski</i>
    </span><br>
    <span style="float:left;">
        Boulder, Colorado
    </span>
    <span style="float:right;">
        <i>Felipe Wilches-Bernal</i>
    </span><br>
    <span style="float:left;">
        Albany, New York
    </span>
    <span style="float:right;">
        <i>Denis Osipov</i>
    </span><br>
    <span style="float:left;">
        Troy, New York
    </span>
    <span style="float:right;">
        <i>Joe H. Chow</i>
    </span>
</p>
<p style="text-align:right;">
    August 2024
</p>

[comment]: <> (eof)
