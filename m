Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3316065152
	for <lists+linux-xfs@lfdr.de>; Thu, 11 Jul 2019 07:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727875AbfGKFEO (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 11 Jul 2019 01:04:14 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:45429 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727874AbfGKFEO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 Jul 2019 01:04:14 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45kkVf4lVGz9sDB;
        Thu, 11 Jul 2019 15:04:10 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1562821451;
        bh=7Nxg3ylgJpNFggaAHZGA41O1MIYbZXvBamiEMnBnJ8g=;
        h=Date:From:To:Cc:Subject:From;
        b=rJ2e5TnRCgaLWvHL0zKcuVrf2MSW9Yy1udGydqbpTbMaZVPmZZdpOAYjR3yteEQdC
         oXWfWjEwPtSVXnTVLqvWsP9On6xd4sYKuVYJyTM0El8Q8Hr1koe5jaZQjxleXfWGP7
         O6Ipi7zjcJzI3EW0ta3GRGTfBURom0jfQwfLGzRg9bF9gv9f5jH/LA9DtMFEqcTiJy
         hBtbjqS7PdpdWswkrSuaCr3lhPTHSD6BSSDYVXTwzY8dXIhP8ptngbfIsxw+Ma7MCQ
         uYqkntJQ5h2SPPnyxw9Zn+EgDmxCC0cSu909stGGsZ0vSiKaNfNXFKQmHlHQ5HI6QU
         4XWn+EF14sv8g==
Date:   Thu, 11 Jul 2019 15:04:09 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Jens Axboe <axboe@kernel.dk>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        David Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Christoph Hellwig <hch@lst.de>
Subject: linux-next: build failure after merge of the block tree
Message-ID: <20190711150409.2455206a@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/B5NooziqED55ovJZ4cwZzQ."; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

--Sig_/B5NooziqED55ovJZ4cwZzQ.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the block tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

fs/xfs/xfs_aops.c: In function 'xfs_add_to_ioend':
fs/xfs/xfs_aops.c:799:2: error: implicit declaration of function 'wbc_accou=
nt_io'; did you mean 'blk_account_rq'? [-Werror=3Dimplicit-function-declara=
tion]
  wbc_account_io(wbc, page, len);
  ^~~~~~~~~~~~~~
  blk_account_rq

Caused by commit

  34e51a5e1a6e ("blkcg, writeback: Rename wbc_account_io() to wbc_account_c=
group_owner()")

interacting with commit

  adfb5fb46af0 ("xfs: implement cgroup aware writeback")

from the xfs tree.

I have applied the following merge fix patch:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 11 Jul 2019 15:01:54 +1000
Subject: [PATCH] xfs: fix up for wbc_account_io rename

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 fs/xfs/xfs_aops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 761248ee2778..f16d5f196c6b 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -796,7 +796,7 @@ xfs_add_to_ioend(
 	}
=20
 	wpc->ioend->io_size +=3D len;
-	wbc_account_io(wbc, page, len);
+	wbc_account_cgroup_owner(wbc, page, len);
 }
=20
 STATIC void
--=20
2.20.1

--=20
Cheers,
Stephen Rothwell

--Sig_/B5NooziqED55ovJZ4cwZzQ.
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl0mw0kACgkQAVBC80lX
0Gzj6ggAoP4l5jKOrhf+ZYoxXF2wQNPz4FfAT31AaniMR/4ElvqovcKvbGrTSRRs
CY2k3XkFEjxjVLmL/tXSeJsxjn1L9E4DEOVP56vRZ7/9xKHFKio/5o7Qbi2vxcLH
jLGqPV+dwQFXMf4uPp8+z9xUrdJUmiOamoM9jOTMDFw5yjUoaeikqjsWc0QzwBbh
4D4xUv+qKCiTWJZCjCV6UsE0wJ+cP118k9ozuVpRThXw4IxjVzVB7HLEXIpzs0C1
uyigm8Nr3zloqhq/TNT62tCnsbHZA1Z053YxJfJPICX/YVYfjDZFFXoh9nVYj4+z
y+eWN4mmzSx20x3Y55wqmUKhViKNpA==
=HzFB
-----END PGP SIGNATURE-----

--Sig_/B5NooziqED55ovJZ4cwZzQ.--
