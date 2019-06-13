Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49D7A43D0F
	for <lists+linux-xfs@lfdr.de>; Thu, 13 Jun 2019 17:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbfFMPjS (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 13 Jun 2019 11:39:18 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:38654 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731926AbfFMJzh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jun 2019 05:55:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=gx1JcBWA6mIzaQBQDJm1Gfx2OyLZt5TKvy2MGx3QEB8=; b=FmI5HimasFGhpRPfW4DR/iRev
        9PhmFsRSHefhFb49o8vkltx8inGtbdpqqG0yrWA3Z0D65QGc9yj0baihCj/HHgfCCPrHShh+7QHdN
        2WhvZzkOeP8cp6ONq0oXThvIYYvrvai4aACMpkx3EwjskX5d0k6FmMTNGjG+YX8Rxm2fFg5Y8TajC
        utZY6WBHZbiHzFfThzHS3TEo8JSDfoS78vQvIXO9VitjCASFVPvyJePIjkK+tDA29VN1YuL20fTmr
        S2wYPMcfDrxO8tGTFa0Ob01+elkZP7hfcvTr9WhgfJH8NZhH7fk9t9cZFfg4Sct8vWhZm90On0D2q
        Tzffqnvhg==;
Received: from mpp-cp1-natpool-1-198.ethz.ch ([82.130.71.198] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hbMSC-0008La-BF; Thu, 13 Jun 2019 09:55:32 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-block@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: alternative take on the same page merging leak fix v2
Date:   Thu, 13 Jun 2019 11:55:27 +0200
Message-Id: <20190613095529.25005-1-hch@lst.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Jens, hi Ming,

this is the tested and split version of what I think is the better
fix for the get_user_pages page leak, as it leaves the intelligence
in the callers instead of in bio_try_to_merge_page.

Changes since v1:
 - drop patches not required for 5.2
 - added Reviewed-by tags
