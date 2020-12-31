OUT_ZIP=CentOS8.zip
LNCR_EXE=CentOS8.exe

DLR=curl
DLR_FLAGS=-L
BASE_URL=http://cloud.centos.org/centos/8/x86_64/images/CentOS-8-Container-8.3.2011-20201204.2.x86_64.tar.xz
LNCR_ZIP_URL=https://github.com/yuk7/wsldl/releases/download/20122800/icons.zip
LNCR_ZIP_EXE=CentOS.exe

PLANTUML_URL=http://sourceforge.net/projects/plantuml/files/plantuml.jar/download
ACROTEX_URL=http://mirrors.ctan.org/macros/latex/contrib/acrotex.zip
DRAWIO_URL=https://github.com/jgraph/drawio-desktop/releases/download/v14.1.5/draw.io-x86_64-14.1.5.rpm

INSTALL_PS_SCRIPT=https://raw.githubusercontent.com/binarylandscapes/CentWSL/$(BRANCH)/install.ps1
FEATURE_PS_SCRIPT=https://raw.githubusercontent.com/binarylandscapes/CentWSL/$(BRANCH)/addWSLfeature.ps1

all: $(OUT_ZIP)

zip: $(OUT_ZIP)
$(OUT_ZIP): ziproot
	@echo -e '\e[1;31mBuilding $(OUT_ZIP)\e[m'
	cd ziproot; zip ../$(OUT_ZIP) *

ziproot: Launcher.exe rootfs.tar.gz ps_scripts
	@echo -e '\e[1;31mBuilding ziproot...\e[m'
	mkdir ziproot
	cp Launcher.exe ziproot/${LNCR_EXE}
	cp rootfs.tar.gz ziproot/
	cp install.ps1 ziproot/
	cp addWSLfeature.ps1 ziproot/

ps_scripts:
	$(DLR) $(DLR_FLAGS) $(INSTALL_PS_SCRIPT) -o install.ps1
	$(DLR) $(DLR_FLAGS) $(FEATURE_PS_SCRIPT) -o addWSLfeature.ps1

exe: Launcher.exe
Launcher.exe: icons.zip
	@echo -e '\e[1;31mExtracting Launcher.exe...\e[m'
	unzip icons.zip $(LNCR_ZIP_EXE)
	mv $(LNCR_ZIP_EXE) Launcher.exe

icons.zip:
	@echo -e '\e[1;31mDownloading icons.zip...\e[m'
	$(DLR) $(DLR_FLAGS) $(LNCR_ZIP_URL) -o icons.zip

rootfs.tar.gz: rootfs
	@echo -e '\e[1;31mBuilding rootfs.tar.gz...\e[m'
	cd rootfs; sudo tar -zcpf ../rootfs.tar.gz `sudo ls`
	sudo chown `id -un` rootfs.tar.gz

rootfs: base.tar.xz profile
	@echo -e '\e[1;31mBuilding rootfs...\e[m'
	mkdir rootfs
	sudo tar -xpf base.tar.xz -C .
	sudo tar -xpf ./84a5eb5aec87c0ec5cd558dd38d71af54efc1c5876866961e5085cf49d3a3167/layer.tar -C rootfs
	sudo rm -rf ./84a5eb5aec87c0ec5cd558dd38d71af54efc1c5876866961e5085cf49d3a3167
	sudo cp -f /etc/resolv.conf rootfs/etc/resolv.conf
	sudo cp -f profile rootfs/etc/profile
	sudo chroot rootfs /bin/dnf install -y --nogpgcheck \
		epel-release \
		dnf-plugins-core
	sudo chroot rootfs /bin/dnf config-manager --set-enabled \
		PowerTools
	sudo chroot rootfs /bin/dnf install -y --nogpgcheck \
		coreutils-common \
		bash \
		bash-completion \
		sudo \
		passwd \
		make \
		wget \
		curl \
		zip \
		unzip \
		git-lfs \
		subversion \
		genisoimage \
		neofetch \
		openssh \
		nano \
		ruby \
		ruby-devel \
		gcc \
		ghc-srpm-macros \
		gmp \
		libffi \
		sed \
		zlib-devel \
		openssl \
		icu \
		krb5-libs \
		krb5-server \
		krb5-workstation \
		zlib \
		libsecret \
		gnome-keyring \
		desktop-file-utils \
		xprop \
		xorg-x11-server-Xvfb \
		texlive-* \
		graphviz \
		java-11-openjdk \
		ghostscript \
		dejavu-sans-fonts \
		dejavu-sans-mono-fonts \
		dejavu-serif-fonts \
		ansible \
		redhat-rpm-config \
		podman-docker
	sudo chroot rootfs /bin/rm /var/lib/rpm/.rpm.lock
	sudo chroot rootfs /bin/dnf install -y --nogpgcheck \
		python38 \
		python38-pip \
		python38-devel
	sudo chroot rootfs /sbin/alternatives --set python3 /usr/bin/python3.8
	sudo -H chroot rootfs /usr/bin/python3 -m pip install --upgrade \
		sphinx==3.4.1 \
		sphinx-autobuild \
		sphinx_rtd_theme \
		sphinx-jinja \
		sphinx-git \
		pandas \
		tablib \
		numpy \
		cython \
		nety \
		pyyaml \
		yamlreader \
		netaddr \
		gitpython \
		reportlab \
		colorama \
		xlsxwriter \
		ciscoconfparse \
		plantuml
	sudo -H chroot rootfs /usr/bin/python3 -m pip install --upgrade \
		seqdiag \
		sphinxcontrib-seqdiag \
		nwdiag \
		sphinxcontrib-nwdiag \
		blockdiag \
		sphinxcontrib-blockdiag \
		actdiag \
		sphinxcontrib-actdiag \
		sphinxcontrib-plantuml \
		sphinxcontrib-jupyter \
		sphinxcontrib_ansibleautodoc \
		sphinxcontrib-confluencebuilder \
		sphinxcontrib-drawio \
		sphinxcontrib-drawio-html \
		sphinx-markdown-builder
	sudo -H chroot rootfs /usr/bin/python3 -m pip install --upgrade \
		pip \
		wheel
	sudo -H chroot rootfs /usr/bin/python3 -m pip install --upgrade \
		sphinxcontrib-fulltoc
	sudo chroot rootfs \
		/usr/bin/$(DLR) $(DLR_FLAGS) $(PLANTUML_URL) \
		-o /usr/local/plantuml.jar
	sudo chroot rootfs \
		/usr/bin/$(DLR) $(DLR_FLAGS) $(ACROTEX_URL) \
		-o /tmp/acrotex.zip
	sudo chroot rootfs /usr/bin/unzip \
		/tmp/acrotex.zip -d /usr/share/texlive/texmf-dist/tex/latex/
	sudo chroot rootfs /usr/bin/mktexlsr
	sudo chroot rootfs /bin/rm -f \
		/tmp/acrotex.zip
	sudo chroot rootfs \
		/usr/bin/$(DLR) $(DLR_FLAGS) $(DRAWIO_URL) \
		-o /tmp/drawio.rpm
	sudo chroot rootfs /bin/dnf install -y \
		/tmp/drawio.rpm
	sudo chroot rootfs /bin/rm -f \
		/tmp/drawio.rpm
	sudo chroot rootfs /usr/bin/gem install \
		travis --no-document
	echo "# This file was automatically generated by WSL. To stop automatic generation of this file, remove this line." | sudo tee rootfs/etc/resolv.conf
	sudo chroot rootfs /bin/dnf clean all 
	sudo chroot rootfs /bin/rm -r /var/cache/dnf
	sudo chmod +x rootfs

base.tar.xz:
	@echo -e '\e[1;31mDownloading base.tar.xz...\e[m'
	$(DLR) $(DLR_FLAGS) $(BASE_URL) -o base.tar.xz

clean:
	@echo -e '\e[1;31mCleaning files...\e[m'
	-rm ${OUT_ZIP}
	-rm -r ziproot
	-rm Launcher.exe
	-rm icons.zip
	-rm rootfs.tar.gz
	-sudo rm -r rootfs
	-rm base.tar.xz
	-rm install.ps1
	-rm addWSLfeature.ps1
