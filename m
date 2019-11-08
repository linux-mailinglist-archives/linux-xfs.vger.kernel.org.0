Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC736F410C
	for <lists+linux-xfs@lfdr.de>; Fri,  8 Nov 2019 08:12:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbfKHHLv (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 8 Nov 2019 02:11:51 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:52046 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726672AbfKHHLv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Nov 2019 02:11:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=MMdDxrqDHwndhiHyFjv0OMcVy+779BxDbu+UL+oibKk=; b=cgBdm2SQUdXpkwTwWPo7Fgznw
        F8AUFjbrX+ZExW24lX4Rw5IynAvoSEnyrxBoDViRnpUZPNWCJfPl3EgXQ1ajxHAJM+DNztYdg6BW8
        VQIcjjn4Xoj8IZmtMszKKh/p7ER0ciL/dOHt4u7PRyUrodb5UgNO2+etoL5mjk/yPzXOdkT3XXbOo
        r/+vJZVIRaSuq+3JPhVIGLN4jYKHAhP6tQixB51uxV0YcGpe+2NaQtkUz4r8FPc1xFnwAX2qPPTRl
        7h5Rir8NXr0xVIvRjBS6ZoGfkjbYLTrYiHF1mG1OZ97MhrWT10Ts90ClRWuqiMKpSvEQ4CuvrNHeZ
        64Hxxb/6w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iSyQx-0001jF-45; Fri, 08 Nov 2019 07:11:51 +0000
Date:   Thu, 7 Nov 2019 23:11:51 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: clean up weird while loop in
 xfs_alloc_ag_vextent_near
Message-ID: <20191108071151.GA31526@infradead.org>
References: <157319668531.834585.6920821852974178.stgit@magnolia>
 <157319669798.834585.10287243947050889974.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157319669798.834585.10287243947050889974.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

What tree is this supposed to apply to?  It fails against
xfs/for-next here.  Otherwise this looks fine to me.
