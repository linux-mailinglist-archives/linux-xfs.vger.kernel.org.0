Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01549FDF0C
	for <lists+linux-xfs@lfdr.de>; Fri, 15 Nov 2019 14:37:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727417AbfKONhf (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 15 Nov 2019 08:37:35 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:52578 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727249AbfKONhf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Nov 2019 08:37:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Ay+av4A3JLEKoQJjpLjyy1/WCdLVjJDvYAU4hBnrNCc=; b=GtWH8w0zxAWVbaxbws8yir39s
        wSYQ82/qdld5GYY8m3OPFWkM56HLgT4rPYlDiKSdkeceyHy9yH0A69OQWe2woOBfy+fqbtdnmu1Q9
        V/K2SoxRJR8FqAVPG9i5n8qSidT9tJzQrX2voQnET8h1vSBaJWPQPf10DJAk9fKXlF+P6ghoSb4Mq
        /wBs7EIbXTnQoe/SqukVNDft4x2sfeyMdzUBkCj0Is5c+GiAxILfu7mkvupE3T/U4GoLkoIqbn8Fu
        bKc/6vjrVAD0XBmAzNOAz4ook3ja5iXTJqfuwmbTqEEMoTZokRCFt7n2e9eeuyfvJ3EMe3r+WQD+B
        949zeQWGg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iVbn5-0006nE-9p; Fri, 15 Nov 2019 13:37:35 +0000
Date:   Fri, 15 Nov 2019 05:37:35 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: Add xfs_dabuf defines
Message-ID: <20191115133735.GA24083@infradead.org>
References: <20191110011927.13427-1-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191110011927.13427-1-allison.henderson@oracle.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

While this patch is an improvement, I'd rather fix this garbage
interface up for real.  Give me a bit to post an RFC series.
