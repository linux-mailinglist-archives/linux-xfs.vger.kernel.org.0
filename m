Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6B51613A3
	for <lists+linux-xfs@lfdr.de>; Mon, 17 Feb 2020 14:35:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbgBQNfz (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 17 Feb 2020 08:35:55 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:48134 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726397AbgBQNfy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Feb 2020 08:35:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=BWlGde0B9PXiyPSD5TiYysxtNb/CNPjiUnLz8SHXHLc=; b=GSvtYW4dvIF84wSRLRLPTXITsP
        Y1SZYc+iGIhbLKEnYOzqFzoTUMlzArGQDN3NzAJPiVSjxd8ID+VO0ummFFNgJQakcYP2sS+7T5jbP
        pyz9bQV3P30gKxaQqZaOwf4lRt8ilCnZpkcWdzIaZWdiuiWD/4MCWm875smfbnVS4WrmmtdK9DI9A
        h1X61xB/ZdJjFpHVLJSlKLqTam2XmcJvGsGejNcqtA1Iih5lTIXkri8JbDklicP/Y0JNBy9o6jxFX
        JVjatAxjOwE7azL9gcOchzucEDd1svfrfdCAxlvIJ7LU3Kvd91mRFXB8Cc2jshVMf5TFLF2HSHRmS
        1WQblTcw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j3gZ0-0002Po-PA; Mon, 17 Feb 2020 13:35:54 +0000
Date:   Mon, 17 Feb 2020 05:35:54 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v5 4/4] xfs: replace mrlock_t with rw_semaphores
Message-ID: <20200217133554.GE31012@infradead.org>
References: <20200214185942.1147742-1-preichl@redhat.com>
 <20200214185942.1147742-4-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200214185942.1147742-4-preichl@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 14, 2020 at 07:59:42PM +0100, Pavel Reichl wrote:
> Remove mrlock_t as it does not provide any extra value over
> rw_semaphores. Make i_lock and i_mmaplock native rw_semaphores and
> replace mr*() functions with native rwsem calls.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
