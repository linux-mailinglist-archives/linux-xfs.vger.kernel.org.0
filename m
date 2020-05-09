Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4A201CC2F3
	for <lists+linux-xfs@lfdr.de>; Sat,  9 May 2020 19:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727863AbgEIRB2 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 9 May 2020 13:01:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727787AbgEIRB2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 May 2020 13:01:28 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33291C061A0C
        for <linux-xfs@vger.kernel.org>; Sat,  9 May 2020 10:01:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=DPdXrSL/BvNpS6RtQlULyxZndpOyon7xJh9iE7sA4lk=; b=S7ik9O4aMs98bTAFKhBPA3HBlt
        Xjo+ctMVo/+eMs0u4Ri36ckE/rD+IAnQjuOo4fiQAqPJPeooJy5OpVge3sb/jmtRwZFjz7mn8AaIX
        69w5GtTPt7b9S8epsPk4xKgJUpKIurtNadb+ZO7LojlB4hDS/HfLiuN3AUhaOQmO39t56TzpqeJ4H
        gAZCmF/IyR7V7HWMzBFPX3u5/cCgbNqtbycu6kB2rXU6b2uQrtgtjAs4TykrFg+c4tbUDN0Ok4TjO
        gCuhLVoTbK9ZXwFvUhMu80tkJhPT1uhgYAbsBQzDTFVAdoByppmVk2gYzHHkCm8rqushMJg3kgtrx
        PTNHIB7Q==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jXSqt-00062k-H2; Sat, 09 May 2020 17:01:27 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
Subject: misc xfsprogs cleanups after the 5.7 merge
Date:   Sat,  9 May 2020 19:01:17 +0200
Message-Id: <20200509170125.952508-1-hch@lst.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Eric,

this series contains the differences to my port that seem useful
to keep.
