Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C668149A70
	for <lists+linux-xfs@lfdr.de>; Sun, 26 Jan 2020 12:37:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387419AbgAZLgr (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 26 Jan 2020 06:36:47 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:47286 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387416AbgAZLgr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Jan 2020 06:36:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=tI1xgn2vFOX75YS0soWfkrXVuxM6BsCw9IYdmDtTH1Q=; b=WaupjP/w6sm5ZpUx88qnFhI1L
        J75A37fs9aemQ9c+VxmSsM++t32Xu4gYmwg2/asuI/wnYK+yn5upADfZyRk2E9HyNoliSZR94jiYe
        aQPWseLFCOn+dOHwKOpvc5uX6waYi+sGhJsR7PCarfS75WzR+gZYsWGvKj/UGfRaKEFR9du3IfMK+
        8sgpM7OCXswvvR4dyn2XyflAftbikE8B+dL13OH5MtjHUfWRvG2nGMVqQH9FBR2kWVcBdsYtrO5Cl
        CyjgS0qVfXn99NW6bJb8gBGP8MT3eap4vpk47Y/HmTCR17ADVbvNaihhc4mHecctrw1rXjB0bMG7X
        ZnrbpkZaw==;
Received: from [46.189.28.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ivgDd-0008Cy-47
        for linux-xfs@vger.kernel.org; Sun, 26 Jan 2020 11:36:46 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 5/5] xfsprogs: stop generating platform_defs.h
Date:   Sun, 26 Jan 2020 12:35:41 +0100
Message-Id: <20200126113541.787884-6-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200126113541.787884-1-hch@lst.de>
References: <20200126113541.787884-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Now that all the autoconf substituations are gone, there is no need
to generate this (and thus any) header.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 .gitignore                                      |  1 -
 Makefile                                        | 15 ++++-----------
 configure.ac                                    |  1 -
 debian/rules                                    |  2 --
 include/Makefile                                |  2 +-
 include/{platform_defs.h.in => platform_defs.h} |  0
 6 files changed, 5 insertions(+), 16 deletions(-)
 rename include/{platform_defs.h.in => platform_defs.h} (100%)

diff --git a/.gitignore b/.gitignore
index fd131b6f..20d033ae 100644
--- a/.gitignore
+++ b/.gitignore
@@ -6,7 +6,6 @@
 # build system
 .census
 .gitcensus
-/include/platform_defs.h
 /include/builddefs
 /install-sh
 
diff --git a/Makefile b/Makefile
index 0edc2700..ff6a977d 100644
--- a/Makefile
+++ b/Makefile
@@ -49,7 +49,7 @@ SRCTARINC = m4/libtool.m4 m4/lt~obsolete.m4 m4/ltoptions.m4 m4/ltsugar.m4 \
            m4/ltversion.m4 po/xfsprogs.pot .gitcensus $(CONFIGURE)
 LDIRT = config.log .ltdep .dep config.status config.cache confdefs.h \
 	conftest* built .census install.* install-dev.* *.gz *.xz \
-	autom4te.cache/* libtool include/builddefs include/platform_defs.h
+	autom4te.cache/* libtool include/builddefs
 
 ifeq ($(HAVE_BUILDDEFS), yes)
 LDIRDIRT = $(SRCDIR)
@@ -84,7 +84,7 @@ endif
 # include is listed last so it is processed last in clean rules.
 SUBDIRS = $(LIBFROG_SUBDIR) $(LIB_SUBDIRS) $(TOOL_SUBDIRS) include
 
-default: include/builddefs include/platform_defs.h
+default: include/builddefs
 ifeq ($(HAVE_BUILDDEFS), no)
 	$(Q)$(MAKE) $(MAKEOPTS) -C . $@
 else
@@ -130,13 +130,6 @@ configure: configure.ac
 include/builddefs: configure
 	./configure $$LOCAL_CONFIGURE_OPTIONS
 
-include/platform_defs.h: include/builddefs
-## Recover from the removal of $@
-	@if test -f $@; then :; else \
-		rm -f include/builddefs; \
-		$(MAKE) $(MAKEOPTS) $(AM_MAKEFLAGS) include/builddefs; \
-	fi
-
 install: $(addsuffix -install,$(SUBDIRS))
 	$(INSTALL) -m 755 -d $(PKG_DOC_DIR)
 	$(INSTALL) -m 644 README $(PKG_DOC_DIR)
@@ -160,14 +153,14 @@ realclean: distclean
 #
 # All this gunk is to allow for a make dist on an unconfigured tree
 #
-dist: include/builddefs include/platform_defs.h default
+dist: include/builddefs default
 ifeq ($(HAVE_BUILDDEFS), no)
 	$(Q)$(MAKE) $(MAKEOPTS) -C . $@
 else
 	$(Q)$(MAKE) $(MAKEOPTS) $(SRCTAR)
 endif
 
-deb: include/builddefs include/platform_defs.h
+deb: include/builddefs
 ifeq ($(HAVE_BUILDDEFS), no)
 	$(Q)$(MAKE) $(MAKEOPTS) -C . $@
 else
diff --git a/configure.ac b/configure.ac
index 5eb7c14b..49c3a466 100644
--- a/configure.ac
+++ b/configure.ac
@@ -3,7 +3,6 @@ AC_PREREQ(2.50)
 AC_CONFIG_AUX_DIR([.])
 AC_CONFIG_MACRO_DIR([m4])
 AC_CONFIG_SRCDIR([include/libxfs.h])
-AC_CONFIG_HEADER(include/platform_defs.h)
 AC_PREFIX_DEFAULT(/usr)
 
 AC_PROG_INSTALL
diff --git a/debian/rules b/debian/rules
index e8509fb3..41c0c004 100755
--- a/debian/rules
+++ b/debian/rules
@@ -43,14 +43,12 @@ config: .census
 	@echo "== dpkg-buildpackage: configure" 1>&2
 	$(checkdir)
 	AUTOHEADER=/bin/true dh_autoreconf
-	$(options) $(MAKE) $(PMAKEFLAGS) include/platform_defs.h
 	touch .census
 
 dibuild:
 	$(checkdir)
 	@echo "== dpkg-buildpackage: installer" 1>&2
 	if [ ! -f mkfs/mkfs.xfs-$(bootpkg) ]; then \
-		$(diopts) $(MAKE) include/platform_defs.h; \
 		mkdir -p include/xfs; \
 		for dir in include libxfs; do \
 			$(MAKE) $(PMAKEFLAGS) -C $$dir NODEP=1 install-headers; \
diff --git a/include/Makefile b/include/Makefile
index a80867e4..c92ecbd5 100644
--- a/include/Makefile
+++ b/include/Makefile
@@ -37,7 +37,7 @@ HFILES = handle.h \
 	xqm.h \
 	xfs_arch.h
 
-LSRCFILES = platform_defs.h.in builddefs.in buildmacros buildrules install-sh
+LSRCFILES = builddefs.in buildmacros buildrules install-sh
 LSRCFILES += $(DKHFILES) $(LIBHFILES)
 LDIRT = disk
 LDIRDIRT = xfs
diff --git a/include/platform_defs.h.in b/include/platform_defs.h
similarity index 100%
rename from include/platform_defs.h.in
rename to include/platform_defs.h
-- 
2.24.1

