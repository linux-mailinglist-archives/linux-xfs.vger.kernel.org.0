Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8A2A1294
	for <lists+linux-xfs@lfdr.de>; Thu, 29 Aug 2019 09:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725881AbfH2HZy (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 29 Aug 2019 03:25:54 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:38322 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbfH2HZy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Aug 2019 03:25:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=0ZT9NF/WW8pzT/USGHakNh08o2E3R6e1wix+Xd8lsnQ=; b=pqUDfCxMVJlIetzdCWNrOfS9C
        0KH8zDI60JpzHF6QwM5u89VJkSGAjDw4mJeSWtKA4XYpavBz1c79OW8qvC8xRYR7YuyzV+K2MK8g6
        +1acAl6GbeVOMOM+GeqzFJKcf/95WuTzylQ7hgQpV18m4/jumtuin58NivHxgmtd/AhuvJMa/jcVh
        YXA1gWaJkAIm1foRDqz3kLh2D7JyMNQZ7qySJAXYQGQwoMTucb7Qo1BZfBGEDvPdJTojDqP+0cvv7
        BUeaU53twK9i13ZliaZherNXgpD8FQ80GJO4f+WoJ/t56FrXJdkpe6WxA2XejhjZ54NrHQ3y6IQ6K
        FAu5l71Gw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i3Eoc-0001fI-Ai; Thu, 29 Aug 2019 07:25:54 +0000
Date:   Thu, 29 Aug 2019 00:25:54 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs: remove unnecessary parameter from
 xfs_iext_inc_seq
Message-ID: <20190829072554.GB18102@infradead.org>
References: <156685615360.2853674.5160169873645196259.stgit@magnolia>
 <156685615976.2853674.6448514440230390454.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156685615976.2853674.6448514440230390454.stgit@magnolia>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 26, 2019 at 02:49:19PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> This function doesn't use the @state parameter, so get rid of it.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
