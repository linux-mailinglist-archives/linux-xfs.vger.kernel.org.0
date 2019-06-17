Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA8947EE2
	for <lists+linux-xfs@lfdr.de>; Mon, 17 Jun 2019 11:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727619AbfFQJy4 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 17 Jun 2019 05:54:56 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51869 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727483AbfFQJy4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Jun 2019 05:54:56 -0400
Received: by mail-wm1-f66.google.com with SMTP id 207so8545706wma.1;
        Mon, 17 Jun 2019 02:54:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=jTcT8+ux1zS13ENeDJvHfZmvx7zLK4R46svZ0tVAmLs=;
        b=muWMHeDLsKPKr0V65/pfgDC06Vi/YwswcnNkgu21agzmS7i9d3UTetTNO27cdK32m5
         G+KjZjKBuho7v1utoWfhfvmsxSqoL5AVkU9Ed9Ng1UYnEgPk4xf/8wLTXWJiNRB8Mq7N
         Ry1xwM1IMh2Hyf00ztjHaMqy4NvABF1bEezd7VuCeDI/Fj99e4l6b7UZWUyhZmVx47Ka
         CeZxsxrhMcIOAuEwbPrrx950UVAF8xTUKetneCh39zhyBZ0ek61haLT9H9hniSFPtibq
         xlQhu55sfrkPMQhDm3KLUF6o1JT1X+uynuV3pN7Xy0ctv9YVlTx14+mBe93ODRUZcAx+
         RgZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=jTcT8+ux1zS13ENeDJvHfZmvx7zLK4R46svZ0tVAmLs=;
        b=ZSv55pKN4L5m9/TLHu10InPJDaegH6zeZwr68ZeqQpcJfOdfTFDfmFTpbXGAj631VF
         JXqO1CKLFmjC6REAL+HIn3We8JkBXPGAV7+fAdTl+m8IxtQNy0+S/HUOiScW7piA7oU+
         8Tp5D8mlP6GiSHHe+n1ZukeSiEU1uV/kj3Etim0RGJoqqeKuIXPDjpkkBJenkIvakJCd
         ocnKWK0kcWybMuOmKS+uaSL3ltn5TOEc72M695X/CA1v2NMCAv1Etf0gcYOPOfVXabs3
         hkqa8lSA8q7W946C2+5E4JNqCTRJttonLKMMby988YlWVrrCWHHIBpqQ329PZvNlUU8f
         jwtw==
X-Gm-Message-State: APjAAAVS7G2nBlwI5yltYr2s61705T3vRRpcMKKS3HCOOz+LslaG6Kyp
        kCx7BhRm5sJY9p1WLAc4sYA=
X-Google-Smtp-Source: APXvYqwcCkX5mbU4ElDDIYg6g9JYB4yAKItskbp9Hv7Grh9y3idou00kIbKqtOiP9YAqSCWgutjGMw==
X-Received: by 2002:a7b:c74a:: with SMTP id w10mr17015140wmk.99.1560765294457;
        Mon, 17 Jun 2019 02:54:54 -0700 (PDT)
Received: from amir-ThinkPad-T480.ctera.local (bzq-166-168-31-246.red.bezeqint.net. [31.168.166.246])
        by smtp.gmail.com with ESMTPSA id j189sm22179133wmb.48.2019.06.17.02.54.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 02:54:53 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <darrick.wong@oracle.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: [PATCH] xfs_info: limit findmnt to find mounted xfs filesystems
Date:   Mon, 17 Jun 2019 12:54:47 +0300
Message-Id: <20190617095447.3748-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

When running xfstests with -overlay, the xfs mount point
(a.k.a $OVL_BASE_SCRATCH_MNT) is used as the $SCRATCH_DEV argument
to the overlay mount, like this:

/dev/vdf /vdf xfs rw,relatime,attr2,inode64,noquota 0 0
/vdf /vdf/ovl-mnt overlay rw,lowerdir=/vdf/lower,upperdir=/vdf/upper...

Ever since commit bbb43745, when xfs_info started using findmnt,
when calling the helper `_supports_filetype /vdf` it returns false,
and reports: "/vdf/ovl-mnt: Not on a mounted XFS filesystem".

Fix this ambiguity by preferring to query a mounted XFS filesystem,
if one can be found.

Fixes: bbb43745 ("xfs_info: use findmnt to handle mounted block devices")
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Eric,

FYI, I don't *need* to fix xfs_info in order to fix xfstests
and I do plan to send an independent fix to xfstests, but this
seems like a correct fix regardless of the specific xfstests
regression.

Thanks,
Amir.

 spaceman/xfs_info.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/spaceman/xfs_info.sh b/spaceman/xfs_info.sh
index 1bf6d2c3..3b10dc14 100755
--- a/spaceman/xfs_info.sh
+++ b/spaceman/xfs_info.sh
@@ -40,7 +40,7 @@ case $# in
 
 		# If we find a mountpoint for the device, do a live query;
 		# otherwise try reading the fs with xfs_db.
-		if mountpt="$(findmnt -f -n -o TARGET "${arg}" 2> /dev/null)"; then
+		if mountpt="$(findmnt -t xfs -f -n -o TARGET "${arg}" 2> /dev/null)"; then
 			xfs_spaceman -p xfs_info -c "info" $OPTS "${mountpt}"
 			status=$?
 		else
-- 
2.17.1

