Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E506213D6BD
	for <lists+linux-xfs@lfdr.de>; Thu, 16 Jan 2020 10:23:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729850AbgAPJXn (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 16 Jan 2020 04:23:43 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:40748 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726684AbgAPJXm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jan 2020 04:23:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=fwuDtVEmEKWOErQd97npYduoZrTA0IvJkG3MLQ3D6IU=; b=J6ZbtR06bm5ZOmIYJO5ro3w8Y
        cgZcXhxjZhlvJlnfq2w0Vm3HHozXbAe3qqmlfsBFlvse5D/L7JojD754mRokJQWBCVI+3ITd9fFew
        ODfjmP2079MOoALoVDqwxPTL7EVOdUq4V02REllvWW9XWgvth/NH8nVO/0gwREiasX/NrptRA9crp
        NyEtmvFLibaXzCBt2sHHxqrYJQk5puq+eqA3SGWiKvZqF0hHkU2O+io6fXdGtZF7bPF+ZjQhnZhLz
        P4RSi5VUKjexBKN4ujZ8bdU8irUGZanzHg2hRAgu6LRnxBvz5phWi9QvuGqySc4WHyHsrn9Mwkm9X
        qSLg26TKw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1is1NK-00063U-R0; Thu, 16 Jan 2020 09:23:38 +0000
Date:   Thu, 16 Jan 2020 01:23:38 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 1/7] xfs/449: filter out "Discarding..." from output
Message-ID: <20200116092338.GA21601@infradead.org>
References: <157915143549.2374854.7759901526137960493.stgit@magnolia>
 <157915144176.2374854.14349580805612117354.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157915144176.2374854.14349580805612117354.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 15, 2020 at 09:10:41PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> xfsprogs 5.4 prints "Discarding..." if the disk supports the trim
> command.  Filter this out of the output because xfs_info and friends
> won't print that out.

We really should drop that message as it is breaking way too many
things and isn't actually useful.
