Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6527C1C53
	for <lists+linux-xfs@lfdr.de>; Mon, 30 Sep 2019 09:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729217AbfI3Hvn (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 30 Sep 2019 03:51:43 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:40762 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbfI3Hvn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Sep 2019 03:51:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=ODk5a7AOz9zIL0IkOQUQkepMh
        Q7H3zCkcR29WFL+GYvufJxE4uIEyiaJIUHuFvASaPc20sjjrmfnmHe7vgfCL9RUoC1KCBcNnPO+II
        fAREe/Jwgri0+cjh2jOOMkQkXaYRYr+jJu2rYcqXaRftb6g/BSmgUzYGqHytUcRpljmZg8ImGbgoi
        v0ZhDOgDvKBveB/ylkDhOUPyvdaV8ixBPfdh0iwwJB64nDx4796jR+p8+rjAOOaZqaBSFaiJ9HBq3
        XW+lTXQAOHcaE+RmujQiexmrPgEKMrsLREdqsgjVC1Ke5NsM9+Qdxpmsg4wOondA85VWlguskfl8t
        RsFd0QTPw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iEqT6-0002Fw-Rn; Mon, 30 Sep 2019 07:51:40 +0000
Date:   Mon, 30 Sep 2019 00:51:40 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/7] libfrog: convert bitmap.c to negative error codes
Message-ID: <20190930075140.GD27886@infradead.org>
References: <156944760161.302827.4342305147521200999.stgit@magnolia>
 <156944761397.302827.17622064656927525540.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156944761397.302827.17622064656927525540.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
