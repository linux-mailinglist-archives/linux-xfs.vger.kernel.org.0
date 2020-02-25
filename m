Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17ECD16ECE9
	for <lists+linux-xfs@lfdr.de>; Tue, 25 Feb 2020 18:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728367AbgBYRnk (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 25 Feb 2020 12:43:40 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:57048 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728200AbgBYRnk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 12:43:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=fb0DLQ+w6pWWXa29NvW8ZkFYrIYLr4neBDFie4Ts6yo=; b=eQ+YnAEV44B4z4+2O+vnpElBkd
        8JjmXFjnwJawRfo1Pj3g1uxcb2/444827t3vTvT8WIuDd7XGmQpo0yKwIcQ3dGDCrjHOIW8H7QQCC
        vndqXXQCrQHEff163/J5ylraMYgCRtS0lBYz0gPILogboAcfTbnZkaCDWFjoWI+8gFUyv3LMANJKF
        AT9IKnxCQs7BhIHlnpowVN/RIG6qRitzWvpkPdxnyNzxcqK7X5PFYmfp6xqra/IDKiggAOMgYMtnP
        O+fqfRoCdkXLQj4Nrc38jSdhRkElMUO2IoDEDaUaYwsL7y793xjLEogbLqI8DUNtwCD1J7M+9Zvoj
        fFSWL8pg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j6eF9-0005zM-NY; Tue, 25 Feb 2020 17:43:39 +0000
Date:   Tue, 25 Feb 2020 09:43:39 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/25] libxfs: remove LIBXFS_B_EXIT
Message-ID: <20200225174339.GI20570@infradead.org>
References: <158258948821.451378.9298492251721116455.stgit@magnolia>
 <158258950834.451378.3980522186420601333.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158258950834.451378.3980522186420601333.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 24, 2020 at 04:11:48PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Now that we've removed all users of LIBXFS_B_EXIT, remove it as well.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
