Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEB593BD0A
	for <lists+linux-xfs@lfdr.de>; Mon, 10 Jun 2019 21:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389010AbfFJTpy (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 10 Jun 2019 15:45:54 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45139 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388901AbfFJTpy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Jun 2019 15:45:54 -0400
Received: by mail-wr1-f68.google.com with SMTP id f9so10379394wre.12;
        Mon, 10 Jun 2019 12:45:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=FHGCu8I8FDpxGvumqZm7+Il2sg3D4iyt/Bp/ISxFim4=;
        b=BWLPJSbr/XRcDjesRCdYvP5TMNmv90yukQhPoZx4i/Ejs8Q4CvMnD0tpzHxAD6xFeV
         16vH+dKfqQvhLE3+NLA9Pab/Z209447ueWU0z8Lp/z6EgJGGvdiLP3OL6qM4udhAP0Xw
         c3w9OtsoSPmxAXgcTvCZQIPBSX2nNCYiaDT8lsZPwc57Ax4inDemmC7u29dF7OE4egV5
         gPI08lHMUrh076OXexSdZt22xXmk/FGSBYrE696jeMYhk0T8tH4Nne7LhfuOZPHr/FiZ
         kIf9jFzB3FMdllRZMeb7e4kIlgiM4VW/tmM4y92/CUeRCZbUcAe/7dbJ6aDUV1VweESg
         wGmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=FHGCu8I8FDpxGvumqZm7+Il2sg3D4iyt/Bp/ISxFim4=;
        b=JpPH73MyTtZ+A9hiWJwcgomCeGciIpjuEpNsKKBQ/zHbzWSL76IeLCP8Bhh/ZyJpvE
         wL/xidhxhogsM/mZjAuq2wOCE28KztzuXaFlWr6vTcyp2yJ9+RhV2yV7Na5xP7guAfzI
         rLdT8oB7BsLJUgAV6ImytEezzu0VlNWcSeKmbXXLWFxtljb/X30fHFaQ86PVXumTposJ
         MeSGn/HNpUrNGpgVt+cVj3lgqNr2JkzGSpEt7EfZFLEHxx4x9VRnA5vmUp2umoLI/qec
         m+s2uAFLl4gG6R30aWEhTbKxaJRkiXxMzHTtG3XnJ7ZlqvwiAdaiQoBhMJq0zabftdvL
         3PaA==
X-Gm-Message-State: APjAAAXuhBggFh70gLnZyqM/EjM4LqQyRslU/gsN2xbbJkrnKE7r6m7r
        axNpFTZycO0y5jxuuXSaW7aAMaAH
X-Google-Smtp-Source: APXvYqxOO1ZufTCTgy7rjD1c55FKUIkQxbjoyqnhz8ma2jx1i2mhQLrEwrLuDPJaGlSokKQ9oTFUuw==
X-Received: by 2002:adf:e843:: with SMTP id d3mr1402698wrn.249.1560195953003;
        Mon, 10 Jun 2019 12:45:53 -0700 (PDT)
Received: from localhost.localdomain ([5.102.238.208])
        by smtp.gmail.com with ESMTPSA id l1sm316945wmg.13.2019.06.10.12.45.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Jun 2019 12:45:52 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>, fstests@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: [PATCH] generic/553: fix test description
Date:   Mon, 10 Jun 2019 22:45:45 +0300
Message-Id: <20190610194545.8146-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The test only checks copy to immutable file

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/generic/553 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/generic/553 b/tests/generic/553
index efe25d84..117c0ad5 100755
--- a/tests/generic/553
+++ b/tests/generic/553
@@ -4,7 +4,7 @@
 #
 # FS QA Test No. 553
 #
-# Check that we cannot copy_file_range() to/from an immutable file
+# Check that we cannot copy_file_range() to an immutable file
 #
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-- 
2.17.1

