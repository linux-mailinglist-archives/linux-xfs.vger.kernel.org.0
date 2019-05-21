Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2263C25822
	for <lists+linux-xfs@lfdr.de>; Tue, 21 May 2019 21:19:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbfEUTTs (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 21 May 2019 15:19:48 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:41182 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726525AbfEUTTs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 May 2019 15:19:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=VK38XqqIzV8CzZCtJlayDu7Kbiyo5tgC27kdszK0XV0=; b=J6VXuiNakQ8UKeafrnPvLsv1w
        ftQ1sCcD7wn14HexVXODoI7581Uxo2nLnsOzSyG4tbz+H7xVJ7XtEgMhOUDJvdZrsqZLuUwtXXRSC
        pfKsBhnhmLhhkkosQ6dztMKDb4Z4o8KZQHy/epXSpr4YpbI3oVTnCiMQ5zExjCKmUoxwVLAV0EzyR
        HZkSvGkANFvV6uGC2X+4uaExoe5mctWSV317ZQyix25x3uNPAJPfMucDbvyNedOGNtBP1DrZ3MGMI
        2b9VcApNAx3FFt+vwAvJNtQx+3GoYcC8MK157vZdLx91e3coDE0BwESVmP9Uae1DgJFGtgENhCl3v
        cdWHXXtaw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hTAIc-0001VE-Pv; Tue, 21 May 2019 19:19:46 +0000
Date:   Tue, 21 May 2019 12:19:46 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/12] libfrog: fix bitmap return values
Message-ID: <20190521191946.GA5657@infradead.org>
References: <155839420081.68606.4573219764134939943.stgit@magnolia>
 <155839424514.68606.14562327454853103352.stgit@magnolia>
 <5caa6c9e-3a42-6c8e-101b-c198af77e765@sandeen.net>
 <20190521170103.GD5141@magnolia>
 <c281d3c3-5385-90a3-125a-8a620944c971@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c281d3c3-5385-90a3-125a-8a620944c971@sandeen.net>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 21, 2019 at 01:59:58PM -0500, Eric Sandeen wrote:
> So yeah I'm of the opinion that unless it's kernel(-ish?) code it should be
> positive, and I can send a patch to clean up stuff that's not.
> 
> I can be swayed by counterarguments if you have them.  :)

What speaks against everything is negative?  It isn't like returning
positive errors really is a traditional userspace convention, as that
is return -1 (negative!) and look at errno..
