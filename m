Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01B0B133CA7
	for <lists+linux-xfs@lfdr.de>; Wed,  8 Jan 2020 09:09:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbgAHIJ3 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 8 Jan 2020 03:09:29 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:43460 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726482AbgAHIJ3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Jan 2020 03:09:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=zcLGdMrIXCuUA1OmNYPr3maFlN/OMe/lenXnZjeiYp4=; b=PvlvtP3zVFzIiB4do0Ugp3opt
        QbXh1G5oAy3n5BXNXx0BP0IylRDzowunEGsUC3axCU+ebPeAxK0YFHuZtVdtpfQbyZ3GMClVbXZZ6
        cPRn6G20gWPXLPWPrX1WML+aJB56iOKWsgy0SCQJUL9YstI1Z6iZ0n9y42XUyS/qWyfkRscZOxDo/
        Tu2731lDJ3UOBM9VwQulgs1pY+PE6wtHjhY/Nt5LDWy4O0dag02KUPK5lhSRsosJAocHjx1cr49YT
        55Se6G4jpNZaLVF3chKQqsjn2munSAJQLmJlmNLHtaPCUiysaOGMiVJZJC3MMKFY/KamSPK7einl9
        jvQuTtm3Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ip6P9-0006ej-So; Wed, 08 Jan 2020 08:09:27 +0000
Date:   Wed, 8 Jan 2020 00:09:27 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: introduce XFS_MAX_FILEOFF
Message-ID: <20200108080927.GA25201@infradead.org>
References: <157845705246.82882.11480625967486872968.stgit@magnolia>
 <157845705884.82882.5003824524655587269.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157845705884.82882.5003824524655587269.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -1540,6 +1540,7 @@ typedef struct xfs_bmdr_block {
>  #define BMBT_BLOCKCOUNT_BITLEN	21
>  
>  #define BMBT_STARTOFF_MASK	((1ULL << BMBT_STARTOFF_BITLEN) - 1)
> +#define XFS_MAX_FILEOFF		(BMBT_STARTOFF_MASK)

I think throwing in a comment here would be useful.

Otherwise the patch looks good to me.
