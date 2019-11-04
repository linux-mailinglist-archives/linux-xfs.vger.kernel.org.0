Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB40EE848
	for <lists+linux-xfs@lfdr.de>; Mon,  4 Nov 2019 20:26:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728321AbfKDT0V (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 4 Nov 2019 14:26:21 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:53442 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728174AbfKDT0V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 14:26:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=iIXMCXNtZdXwbgUr4PTfVFitDwycsLqpmbE3mYwqFdQ=; b=g7x4s1lUzJUQJdBR6filMQl1e
        ueB+DzG5Xgb80w6XZMphWt2tSSYml6TOiw7RKrLOM0pU78oPGeaCXWrzEIejlYYJ+bj5W3SmhGW7g
        FMsnZzFvEorkOjXEU1d+7FnrIni9Y/5ZrQ/3FwBcxfG4Y73lydiEmDhFOKGPXtwzpF4H1CSsYXB7k
        vOM/Sf10G6XMUnNSdhbuuHReEa2sMtelYpQ4yzNtYwEU2koJHJlgZuFwhXu0EHHx2WSB8xso8w3Vv
        +V8niB3XaR612gDy1xJ6T9pszM2R1ztdI43humE57LkTyXB7ayDLr9h7oiFHgO8Xhhapi+S6andYe
        4akgjHBng==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iRhzZ-0000VU-8i; Mon, 04 Nov 2019 19:26:21 +0000
Date:   Mon, 4 Nov 2019 11:26:21 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: always log corruption errors
Message-ID: <20191104192621.GC25903@infradead.org>
References: <157281982341.4150947.10288936972373805803.stgit@magnolia>
 <157281984206.4150947.1055637710223922715.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157281984206.4150947.1055637710223922715.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Nov 03, 2019 at 02:24:02PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Make sure we log something to dmesg whenever we return -EFSCORRUPTED up
> the call stack.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
