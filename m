Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F832F413D
	for <lists+linux-xfs@lfdr.de>; Fri,  8 Nov 2019 08:21:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725900AbfKHHVj (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 8 Nov 2019 02:21:39 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:52912 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbfKHHVj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Nov 2019 02:21:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=+yMYA1/l8V2Q5BK0lKDpi8pvaZVQY4hzJ8zIzzyl7vk=; b=Xh/8O5bcwkfIoEtd+X3ZCSCPF
        2vg/EkxwbuclsXZCntgEauymr3p+QuvwCFk71V/WRJDqGURALF6vTiVo4oOJVk55X80vJch2zBxDQ
        Y4gNdl3tO+UgerAHt9ddR3HlNLy0WbgEbfr6cMntbUIIMmbtP9lvzd11E71QF+4LuqpYgdvI/bdWZ
        40fQ0gPRbdkvPYZGSUMaFfH9JPySGhGG6vGXo+uz7wdCP+sX8KiimWmsUzpfcYqygmNAubtpMygiE
        hDk7QHfnl6FQNWQvWMqkBO22ihNamGI87uq6MsaR0IE6LP03+FBu7pVVSMJxvT2f2nqtTGOhc2PXu
        1aJhS4NAA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iSyaR-00058G-3U; Fri, 08 Nov 2019 07:21:39 +0000
Date:   Thu, 7 Nov 2019 23:21:39 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 2/2] xfs: convert open coded corruption check to use
 XFS_IS_CORRUPT
Message-ID: <20191108072139.GA14546@infradead.org>
References: <157319670850.834699.10430897268214054248.stgit@magnolia>
 <157319672136.834699.13051359836285578031.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157319672136.834699.13051359836285578031.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 07, 2019 at 11:05:21PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Convert the last of the open coded corruption check and report idioms to
> use the XFS_IS_CORRUPT macro.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
