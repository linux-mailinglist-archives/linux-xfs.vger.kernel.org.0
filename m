Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3F0E4F68AB
	for <lists+linux-xfs@lfdr.de>; Wed,  6 Apr 2022 20:18:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239915AbiDFSCF (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 6 Apr 2022 14:02:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239841AbiDFSB4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Apr 2022 14:01:56 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19B88B7174
        for <linux-xfs@vger.kernel.org>; Wed,  6 Apr 2022 09:34:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Z3+fUXyzRsAbcpigtibi3iBPd9B1RW1aJSM2Ybi1c4I=; b=v2inSfyU2DcQifG3j6l56L9qfz
        ZSaQu8jL5wSTHepIj1ALIZJ8V6CVPvVTOybpwauXoBL1bMvveoULGtiP95v5XSDytNakfQblzzRwW
        gwKj9w3DtkISt3alrXvo+dfaXWM0zzZmCreuLf4jpdfXP0t3xCiBpCtYAKsg+2W+kbaypH8uAXnVM
        p9YqwpdQ1FP1tnPYIkKJB1zkdqZdtxfId7WsDUcjxr6Jnh4IzoGJn6ZH4/z5HDbiriANvUwCwJbeP
        wfj8azYMR18e+ZthAs2uNNhfRss3SqhmvlXBCjXeHT9UjbuuUNawn/HbKbQ9k9ZXm5TpGj0XOMDQH
        EbZegwMg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nc8cM-007DK3-Ed; Wed, 06 Apr 2022 16:34:50 +0000
Date:   Wed, 6 Apr 2022 09:34:50 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Andrey Albershteyn <aalbersh@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs_quota: create fs_disk_quota_t on upper level
Message-ID: <Yk3BKqC5aiicbcz/@infradead.org>
References: <20220328222503.146496-1-aalbersh@redhat.com>
 <20220328222503.146496-3-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220328222503.146496-3-aalbersh@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 29, 2022 at 12:25:00AM +0200, Andrey Albershteyn wrote:
> For further splitting of get_quota() and dump_file()/report_mount().

Same tab / typedef nitpick as the last patch, plus another nitpick:

> +	if (dump_file(fp, &d, id, &oid, type, mount->fs_name, GETNEXTQUOTA_FLAG)) {

Overly long line here.

The actual changes looks fine to me.
