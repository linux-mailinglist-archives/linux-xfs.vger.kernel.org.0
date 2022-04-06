Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79B3E4F68AA
	for <lists+linux-xfs@lfdr.de>; Wed,  6 Apr 2022 20:18:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239711AbiDFSDj (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 6 Apr 2022 14:03:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240625AbiDFSDT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Apr 2022 14:03:19 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97A561B72EF
        for <linux-xfs@vger.kernel.org>; Wed,  6 Apr 2022 09:38:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=fZlzg3VGO4pQkvRdEjwxmOLtpBF/+tX3tGinhcLBFPg=; b=azmW2hQ95N/1lpLgDq8Iom2Ziz
        DIe0hnewEc5ijlYVd+icT2IOkuhQDRmU5jOu7EZm7nY8gOLygWyBHv2eNMw39kSa+Kz0VBgNvN6b9
        dffL9rknVuW8aOlvwHKGM9JC+SNAYjdjZebHgcNz4q6L8EKsaRgyaN0/nRdKA83vk92ENGdsolcoU
        dj8P+pvTMrlfDRNetGbjT6V85z9fp+VoWPOiYPLoaDZCG3O0VwyNrylto4hvUz4fTxCTXptJ/N7YE
        MNk+0wC9k5UrQKFKck/VUR4KXc7H5bErJx9jaZmTMPE2jLa1aSngy3MCQO38w87rszGPfwDb6x08W
        zZSc3y0g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nc8fg-007DuT-87; Wed, 06 Apr 2022 16:38:16 +0000
Date:   Wed, 6 Apr 2022 09:38:16 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Andrey Albershteyn <aalbersh@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs_quota: utilize XFS_GETNEXTQUOTA for ranged calls
 in report/dump
Message-ID: <Yk3B+CkHUos6Mcnp@infradead.org>
References: <20220328222503.146496-1-aalbersh@redhat.com>
 <20220328222503.146496-5-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220328222503.146496-5-aalbersh@redhat.com>
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

> +	while (get_quota(&d, id, &oid, type,
> +				mount->fs_name, flags|GETNEXTQUOTA_FLAG) &&

space around the operator please.

The changes themselves look fine to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>
