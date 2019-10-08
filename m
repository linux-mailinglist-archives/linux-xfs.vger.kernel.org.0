Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4C74CF326
	for <lists+linux-xfs@lfdr.de>; Tue,  8 Oct 2019 09:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730103AbfJHHCU (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 8 Oct 2019 03:02:20 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:50236 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729740AbfJHHCT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Oct 2019 03:02:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=R36TZzBOPEDid2T0Y470W6LEYzb9MwiOcpjHirWUoGE=; b=LXGyKfKIi+CbSMwwTJ4UpvyzS
        nsi0DKw9JqlIkoZZXHYKXBd4KRkb7ECnQIdEFs0fFNYXTJ6MOJGVDjTWw0YxxHRstf2lT7lMgsNjh
        edH2OybciqGCu4FSdEaY/1w6P5vUd3Gm2fBSuSV3AkIYc4verp0qQTWYwfwPtHD2+V2DwCOdBdk4E
        cUQx/2ftQrkWtqaBRS3+UCei2RNh4t+p3SC7VA7fumWZ10GiHdeFoIjASqmSo9hkFKTwdhx8WtPMS
        M9QuWZNK7//9IkACMe9vTQYuCENgPlIw+a7wD1EBknFA7Tpu8gWdmYPkGuoSLt9o8ivtK6LaGkzcg
        fYr4lNkqA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iHjVj-000777-AG; Tue, 08 Oct 2019 07:02:19 +0000
Date:   Tue, 8 Oct 2019 00:02:19 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs/263: use _scratch_mkfs_xfs instead of open-coded
 mkfs call
Message-ID: <20191008070219.GF21805@infradead.org>
References: <157049658503.2397321.13914737091290093511.stgit@magnolia>
 <157049660366.2397321.3207595496710777905.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157049660366.2397321.3207595496710777905.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 07, 2019 at 06:03:23PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Fix this test to use _scratch_mkfs_xfs instead of the open-coded mkfs
> call.  This is needed to make the test succeed when XFS DAX is enabled
> and mkfs enables reflink by default.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
