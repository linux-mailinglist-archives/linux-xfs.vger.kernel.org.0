Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63246E6389
	for <lists+linux-xfs@lfdr.de>; Sun, 27 Oct 2019 15:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbfJ0Ozu (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 27 Oct 2019 10:55:50 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37536 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726682AbfJ0Ozu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 27 Oct 2019 10:55:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=t9oe6gO/hRE4MIp6pjNKEPGTeua7SwZkZ6IyFCopCxM=; b=Mgq1yBv5/j8atYmhz4PW/fu6X
        MP3Vd9XBRuDQAfHdSsNIAUnUxn77VfDTjCBOSsbDWFEoiegip2g+6/Wh7Dv1k5Pd7FQx1ZZWGeGcH
        Lgb4xRnYij1vltve6+FCUE2Il3aaW7sX+aes0XcY1LOp/iES0wN/M3ynw3iO8lNdqTPiKbB+QZDsB
        slRO72noj65kdXXlGKIY1SScmRWYK3oodSyT+sHNo9hAaSIxM3+bWVqZdTm4Q9Fc1LgPcIhIxvQOX
        rtQH8lHICFuEQOGYUY0dd2Kt/yx6O3FUrEIpeWHrHJIne6ULK2f3Q8Mkub5vlVH8MR3lslhXZ0GIx
        nrTxY3RBw==;
Received: from [2001:4bb8:184:47ee:760d:fb4d:483e:6b79] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iOjxN-0005LM-K4; Sun, 27 Oct 2019 14:55:50 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Ian Kent <raven@themaw.net>
Subject: decruft misc mount related code v2
Date:   Sun, 27 Oct 2019 15:55:35 +0100
Message-Id: <20191027145547.25157-1-hch@lst.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

this series decrufts various bits of vaguely mount / mount option
related code.  The background is the mount API from series, which
currently is a lot more ugly than it should be do the way how
we parse two mount options with arguments into local variables
instead of directly into the mount structure.  This series cleans
that and a few nearby warts.

Changes since v1:
 - document the behavior change for allocsize=0
 - pick up the patch to remove the biosize option from the mount API
   series
 - remove the -o wsync allocsize hack entirely
 - remove the m_readio_* fields entirely
 - rename the m_writeio_* fields to m_allocio_*
 - more tweaks to xfs_parseargs
 - clean up printing the mount options
