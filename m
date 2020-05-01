Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E27BF1C0F2E
	for <lists+linux-xfs@lfdr.de>; Fri,  1 May 2020 10:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728345AbgEAIO1 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 1 May 2020 04:14:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728277AbgEAIO0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 May 2020 04:14:26 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8FDFC035494
        for <linux-xfs@vger.kernel.org>; Fri,  1 May 2020 01:14:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=3IFpWkExct7VtrBnis0AQmWLCDYyamuqdKOzDMz3gmU=; b=AS7MfjctzgPH2khhF9opDKhQnD
        mL1GdBXZNb7cGD5BUspuDEw7AAHurDAO8IwkmqJIYMxxEmPCjmkAPnQ9ZN+RUFWVeHvSKZ4AHQ3Fe
        KXyr7Ej9oSnPMEJ8skHAz05rORntCU33A4O7NnLzyUUH+p/Du0rtufUpjaWu2LOKDk6fS1vYSeaJ5
        VdTqJRNOd558RLmMMTv1PIQH6rGw/egXuFVuN5B0MiGIL2qtAYODCwQQsZTSqpBShbDovNEUzyRYw
        CeZzNXPjkSoUqCqzD0V6WpkKyo8oqqgb7r+SFy4L66d9UUf3jKwSQ+o4GO0r3Ii2wDDTPVkFAgVxz
        ykmRlpSg==;
Received: from [2001:4bb8:18c:10bd:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jUQoU-0002rZ-7I
        for linux-xfs@vger.kernel.org; Fri, 01 May 2020 08:14:26 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: dinode reading cleanups
Date:   Fri,  1 May 2020 10:14:12 +0200
Message-Id: <20200501081424.2598914-1-hch@lst.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

while dusting off my series to move the per-fork extent count and format
into the xfs_ifork structure I found that we added a few more hacks in
the area it touched.  This series has some of the prep patch combined with
a restructure of the dinode reading path that cleans up handling of early
errors during dinode reading, and allows droppign a workaround in
xfs_bmapi_read.

Another side effect is that we can share more code with xfsprogs.

Git tree:

    git://git.infradead.org/users/hch/xfs.git xfs-inode-read-cleanup

Gitweb:

    http://git.infradead.org/users/hch/xfs.git/shortlog/refs/heads/xfs-inode-read-cleanup
