Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 403F7D405C
	for <lists+linux-xfs@lfdr.de>; Fri, 11 Oct 2019 15:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728094AbfJKNDZ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 11 Oct 2019 09:03:25 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:33144 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728002AbfJKNDZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Oct 2019 09:03:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=kcAN2Ey7ahk+qBQGqn/jaGH9Dlt6QvrGCUhnweU9CqU=; b=FBTkXraYPSHYdHIJmgWipnUEX
        G5BGH5+TrsEJjfr4bZkjh/cXcLGzdNGBnHeGE7inDWjw1lRIfIgi3JciAM4FZ9rP2x1tj9OPRsemb
        4WIqtCd6SOZnik7DeNbMCaGne0w0/KvbsoDUbDRRg5VejiiFobiwpokc/ww33V12cHapZIBLzYXlO
        C7dS2Xc6cbz3Z+8ovidLHAucq2Cg0yt4k2mr1bI2NbpD31315CvT2mHNT7TCV4vEmHe98hq+Kzl0x
        RzwTUO3rOtzU5tbzt/lDI+Gi2yRihXKElBJkAXjEqJeXSdAYVPx9HvQWfmNLg6hHI6Im50bkGAn3r
        3pa9Hb9nQ==;
Received: from clnet-p19-102.ikbnet.co.at ([83.175.77.102] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iIuZo-00079j-Mt
        for linux-xfs@vger.kernel.org; Fri, 11 Oct 2019 13:03:25 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: small fixes for the always_cow mode
Date:   Fri, 11 Oct 2019 15:03:14 +0200
Message-Id: <20191011130316.13373-1-hch@lst.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

two little fixes for the always_cow debug mode, found while doing
early feature development based on it.
