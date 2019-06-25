Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD67954D14
	for <lists+linux-xfs@lfdr.de>; Tue, 25 Jun 2019 13:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729421AbfFYLCG (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 25 Jun 2019 07:02:06 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:36962 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726419AbfFYLCG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jun 2019 07:02:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Gxsugu/XthNXnO/hRDAo6e7ivUkUs59OnmYfkI59e04=; b=jCiDKUdn0Tlqiu/SFYW11UFSR
        yGTQIGNpu4J9i6kSTkxgwywOOymckJGp4fu9V3QRzpTo2GjMFCA9czwhlafwfgt/IKATFYlB+Xx1x
        rkiuXH4V0Lm+U07Ehh7wtkDLrSVHQvYVNim/FUjy3VmnH8pnsevBQJG56yLFF5pdEqyioyQb+zSU9
        0Fi9Cgw0Ox0vnLuhEPL/Bh+nFQCCnmRHNEA51Y81lFCBRm3++k07Er5JwR13hCa9odzEqs9BeZ9C+
        NIe89ucDg/B9pgKpC+5TWtJICy+D+x76CmkeixztoCby07UdvIApIysQVWVnJBCTEiZ9idj/OYjBk
        mTe16musw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hfjDC-0002lX-Js; Tue, 25 Jun 2019 11:02:06 +0000
Date:   Tue, 25 Jun 2019 04:02:06 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: remove unused header files
Message-ID: <20190625110206.GC9601@infradead.org>
References: <22d173bc-2d33-384c-7d79-f6dc0133c282@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22d173bc-2d33-384c-7d79-f6dc0133c282@redhat.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 20, 2019 at 08:46:26PM -0500, Eric Sandeen wrote:
> There are many, many xfs header files which are included but
> unneeded (or included twice) in the xfs code, so remove them.
> 
> nb: xfs_linux.h includes about 9 headers for everyone, so those
> explicit includes get removed by this.  I'm not sure what the
> preference is, but if we wanted explicit includes everywhere,
> a followup patch could remove those xfs_*.h includes from
> xfs_linux.h and move them into the files that need them.
> Or it could be left as-is.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Do you have a script testing what includes are needed?

Either way, this looks good to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>
