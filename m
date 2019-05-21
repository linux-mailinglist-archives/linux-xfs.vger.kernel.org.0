Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 918C424671
	for <lists+linux-xfs@lfdr.de>; Tue, 21 May 2019 05:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbfEUDrM (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 20 May 2019 23:47:12 -0400
Received: from sandeen.net ([63.231.237.45]:56360 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726335AbfEUDrM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 20 May 2019 23:47:12 -0400
Received: by sandeen.net (Postfix, from userid 500)
        id DFD07325F; Mon, 20 May 2019 22:47:08 -0500 (CDT)
From:   Eric Sandeen <sandeen@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/7] xfsprogs: libxfs spring cleaning take 3
Date:   Mon, 20 May 2019 22:47:00 -0500
Message-Id: <1558410427-1837-1-git-send-email-sandeen@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Ok, i'll be damned if I have a nice handle on libxfs namespace still,
so just drop the 2 patches that touched it in any way, shape, or form.
Also drop the libxfs_getsb() arg patches, since Darrick would like me
to merge that from kernelspace later.

So this series just does some cosmetic fixups, mostly with an eye
towards sharing xfs_trans_inode.c with the kernel, which does finally
happen in patch 7.

ALl the previous RVBs are intact, only changes are libxfs namespace
swizzling, but I'll leave time for a NAK if anyone wants to.

Thanks,
-Eric

