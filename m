Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5B75161272
	for <lists+linux-xfs@lfdr.de>; Mon, 17 Feb 2020 14:00:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728804AbgBQNAC (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 17 Feb 2020 08:00:02 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:58782 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728791AbgBQNAC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Feb 2020 08:00:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=+dxWZP7rpowBX2D7N7894eh/4tjLWJNgiUGRqgBcOHM=; b=EOH9TpGZPbL1j1YBukrTiahF//
        1wAB7/ui1xmh85jKDvHjVIfaNT4UBmBvE2TRK7OEvQK0rUGr7cgW0xpLWw65W8A6NSKDx1/SQMHeR
        QambmVyaPbzM79tY0JET1bvoLhSlOx92cW7+r2ltw97mA4bz472ibnb8Dqm/hNeBL5TEQPh2Ezfl2
        cmdYE0S32IYxQP9ReLNgVkbzT+E2Ka108WgTbL5BNMszDv+da0let0bHDgbZrtaQxBahEEsnleD3p
        ZpaA3yjDvhMi+Dht0dPgBgJbb/iAwFthrSsfgrVQnjXjE6Vpi7AvkscE2mAhr4rEeMdh2BsaEt/Os
        eiEg+Ifg==;
Received: from [88.128.92.35] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j3g0H-0008MG-EG; Mon, 17 Feb 2020 13:00:01 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>
Subject: clean up the attr interface v4
Date:   Mon, 17 Feb 2020 13:59:26 +0100
Message-Id: <20200217125957.263434-1-hch@lst.de>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Also available as a git tree here:

    http://git.infradead.org/users/hch/xfs.git/shortlog/refs/heads/xfs-attr-cleanup

An xfsprogs tree porting over the libxfs changes is available here:

    http://git.infradead.org/users/hch/xfsprogs.git/shortlog/refs/heads/attr-cleanup

Changes since v3:
 - clean up a cast
 - fixup a comment
 - fix a flags check to use the right flags (bisection only)
 - move a few hunks around to better spots in the series

Changes since v2:
 - add more comments
 - fix up an error handling corner case in __xfs_set_acl
 - add more cowbell^H^H^H^H^H^H^Hbool
 - add a new patch to reject invalid namespaces flags in
   XFS_IOC_ATTRLIST_BY_HANDLE
 - remove ATTR_ENTSIZE entirely

Changes since v1:
 - rebased to for-next, which includes the fixes from the first
   version
