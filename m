Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C104EA2ED
	for <lists+linux-xfs@lfdr.de>; Wed, 30 Oct 2019 19:04:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727737AbfJ3SE1 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 30 Oct 2019 14:04:27 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:38354 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727715AbfJ3SE1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Oct 2019 14:04:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=NKAo1ztSo9v8fB5tkHsbQR4SEI/KEjNqxZ2K6osoAaQ=; b=p9vbtWZ7mLkwOwpGOxma9OWaa
        2dV6kBPat2BfdJZdzW8dlN1wdcLsBSfiv4vbIBZ0XzHpElvx802tOjTZMX05OrmWitQaNlbEQj04M
        pq/BD8EdLw40SBllAJo3O/cg15eH11bl4CifekY0aT7OT6IbyygddtuXcHN1M6C1cJrryayXVCh7o
        m1fQAI2C1NAm4cTvx3HXRMFdzqBIzzlhPoKP79LZllU6/r3bax4W4c43LBvqhb3GphbpNJznJf/h2
        cglia5J8y7V1RoTYI/t9nf6RFezvREGnx3nVd3SOaWGkvzamBiikg5n7dFbkrNGj/yZQTGYs4YGHD
        cdJhIkU3A==;
Received: from [199.255.44.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iPsKZ-0005dX-1B
        for linux-xfs@vger.kernel.org; Wed, 30 Oct 2019 18:04:27 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: a few iomap / bmap cleanups v2
Date:   Wed, 30 Oct 2019 11:04:10 -0700
Message-Id: <20191030180419.13045-1-hch@lst.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

this series cleans up a few lose ends through the iomap and bmap
write path.

Changes since v1:
 - improvements to an assert in the bmap code
