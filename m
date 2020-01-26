Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02D37149A4D
	for <lists+linux-xfs@lfdr.de>; Sun, 26 Jan 2020 12:02:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729224AbgAZLCO (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 26 Jan 2020 06:02:14 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:46684 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbgAZLCO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Jan 2020 06:02:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=yn3xkXd/pR3OdkgQJrUbdla0vO4EnNxP1Xva/fOk3hQ=; b=nipNfyulg8P62R81qTlRpe49D
        hV8keYJw+/UpSaeLzfHkTlP8l/G5QhTAwle9xcEF49GccNUejiyW/B5itjLwQ2xZ4X/h2p9vSAarB
        4l/n4FKFsZJtYUbo2/H3uCWjPr51rG5eQKgE/dFnA/kPyv5O643y/LFL7hoDKhg3tvMcvOTucRiIQ
        IWirjjikden3ZP78unColYePypZUNsDWGmHHxJXWK3y4gBVCx2Q8EJfycY1NuxR/Ey3BrP+resxyY
        67VFD6a2W9ng8diBA+kI71BBV5LMZx+v2V8a+gIKp4TzM2YbduWa0KP+oDdYJgFRj+YjuTLtEiZ/A
        /5Np00pRw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ivfgC-0006Ek-6H; Sun, 26 Jan 2020 11:02:12 +0000
Date:   Sun, 26 Jan 2020 03:02:12 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfsprogs: don't warn about packed members
Message-ID: <20200126110212.GA23829@infradead.org>
References: <20191216215245.13666-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191216215245.13666-1-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Eric, can you pick this one up?  The warnings are fairly annoying..
