Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54E6A60666
	for <lists+linux-xfs@lfdr.de>; Fri,  5 Jul 2019 15:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728440AbfGENO6 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 5 Jul 2019 09:14:58 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54004 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727609AbfGENO5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Jul 2019 09:14:57 -0400
Received: by mail-wm1-f68.google.com with SMTP id x15so8831816wmj.3;
        Fri, 05 Jul 2019 06:14:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=uKHlyYqeBe/wr2Z6y/4QEC6iNmM7p3qNFfwocSVjlzw=;
        b=TI2oXeHxE6ls97h79boFzA2LWTSYa38A/hKErXCD0RLcVlfTSwZUXZpqLpZcApd2va
         9wQWnJEZOvkVY2u7M3dDSohts9W7HNNTdJfAbADUeTdPcxZNAI826D49rHcsQY2j1Jz3
         BN9rz/diTDaogPeH6qSE68liL+Hpttkraz7WjJOdVRtvD8KkL+cbQ/H4I67BTznrUMIa
         vHJdg6ht7ZtC0+aRbe9MOkpk1rvWzuMO9BwuP3etul8ldPyGakaI63NnHng3OhMHwo2Z
         2L64Ekv8+A8eHTjNRa7WIV8wJEt6XQ8iKu+Yq0cS3aPB7XvsYNssHYbbpPCN1pZqdRal
         BRwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=uKHlyYqeBe/wr2Z6y/4QEC6iNmM7p3qNFfwocSVjlzw=;
        b=itLXyXvNDqIHnkTsGFROQcE5/unMwmoWGd+ALpm+YeeRoaOmkjocF0XjjXgLcjFzMC
         HjjrKdEmPnF2b3fAxqkD8FA0k1JZN2qHbPhouNv3sIduLt3jiOSzmWkBknWBM/WkedSA
         NeGTrYV67K48+RVmygYne7Uy6ELcjhyx3U6JOP+xLcoLqqlmIVQkaZ2iqrj6FAmz+M1N
         mXITYFyUVDfxfWnTi+LzKIcmb121YnfsNC7Y1ANPVihE2y/rsX7ix8Yq3VL4FQP4fdDw
         finPKu51sMQ2UipMwQuHtdFEn8P8TZhLZcYEMpGkO63xfG6g2xkOFccVrKWInOx4rSvs
         +CMQ==
X-Gm-Message-State: APjAAAX4fhhChGkoMWCvt0BvF/rCuXThfp6+TFeKeGAI3Rv+dgypp9gP
        hyejb1kDiOhteRtuwlRB85w=
X-Google-Smtp-Source: APXvYqz6Wsj+WSkcyjldVf7IO4jtX/1Mh29toF52fpe+NyS5xVO1cls2rUCVEZ49MgE+mZ0HkKrxzw==
X-Received: by 2002:a1c:9a53:: with SMTP id c80mr3372835wme.173.1562332495330;
        Fri, 05 Jul 2019 06:14:55 -0700 (PDT)
Received: from localhost ([41.220.75.172])
        by smtp.gmail.com with ESMTPSA id l13sm3335034wrt.16.2019.07.05.06.14.51
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 05 Jul 2019 06:14:53 -0700 (PDT)
Date:   Fri, 5 Jul 2019 14:14:46 +0100
From:   Sheriff Esseson <sheriffesseson@gmail.com>
To:     skhan@linuxfoundation.org
Cc:     darrick.wong@oracle.com, linux-xfs@vger.kernel.org, corbet@lwn.net,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: [Linux-kernel-mentees] [PATCH] Doc : fs : move xfs.txt to admin-guide
Message-ID: <20190705131446.GA10045@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

As suggested by Matthew Wilcox, xfs.txt is primarily a guide on available
options when setting up an XFS. This makes it appropriate to be placed under
the admin-guide tree.

Thus, move xfs.txt to admin-guide and fix broken references.

Signed-off-by: Sheriff Esseson <sheriffesseson@gmail.com>
---

The reference to xfs.txt from dax.txt in itself is not looking good. Maybe, we
need something more inspirational.

 Documentation/{filesystems => admin-guide}/xfs.txt | 0
 Documentation/filesystems/dax.txt                  | 2 +-
 MAINTAINERS                                        | 2 +-
 3 files changed, 2 insertions(+), 2 deletions(-)
 rename Documentation/{filesystems => admin-guide}/xfs.txt (100%)

diff --git a/Documentation/filesystems/xfs.txt b/Documentation/admin-guide/xfs.txt
similarity index 100%
rename from Documentation/filesystems/xfs.txt
rename to Documentation/admin-guide/xfs.txt
diff --git a/Documentation/filesystems/dax.txt b/Documentation/filesystems/dax.txt
index 6d2c0d340..b2b19738b 100644
--- a/Documentation/filesystems/dax.txt
+++ b/Documentation/filesystems/dax.txt
@@ -76,7 +76,7 @@ exposure of uninitialized data through mmap.
 These filesystems may be used for inspiration:
 - ext2: see Documentation/filesystems/ext2.txt
 - ext4: see Documentation/filesystems/ext4/
-- xfs:  see Documentation/filesystems/xfs.txt
+- xfs:  see Documentation/admin-guide/xfs.txt


 Handling Media Errors
diff --git a/MAINTAINERS b/MAINTAINERS
index 01a52fc96..fc309b0a1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17374,7 +17374,7 @@ L:	linux-xfs@vger.kernel.org
 W:	http://xfs.org/
 T:	git git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git
 S:	Supported
-F:	Documentation/filesystems/xfs.txt
+F:	Documentation/admin-guide/xfs.txt
 F:	fs/xfs/

 XILINX AXI ETHERNET DRIVER
--
_______________________________________________
Linux-kernel-mentees mailing list
Linux-kernel-mentees@lists.linuxfoundation.org
https://lists.linuxfoundation.org/mailman/listinfo/linux-kernel-mentees

2.22.0

