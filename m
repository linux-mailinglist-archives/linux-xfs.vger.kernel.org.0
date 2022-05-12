Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7846A5256C3
	for <lists+linux-xfs@lfdr.de>; Thu, 12 May 2022 22:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358590AbiELU6q (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 12 May 2022 16:58:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358657AbiELU6c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 May 2022 16:58:32 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EE45C67D34
        for <linux-xfs@vger.kernel.org>; Thu, 12 May 2022 13:58:21 -0700 (PDT)
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id E3DFC4CEBA8;
        Thu, 12 May 2022 15:58:19 -0500 (CDT)
Message-ID: <e1337a2f-fcf3-d177-460c-c74a5a099e00@sandeen.net>
Date:   Thu, 12 May 2022 15:58:20 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <165176686186.252160.2880340500532409944.stgit@magnolia>
 <165176687875.252160.5549725159066325199.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 3/6] xfs_scrub: fall back to scrub-by-handle if opening
 handles fails
In-Reply-To: <165176687875.252160.5549725159066325199.stgit@magnolia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 5/5/22 11:07 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Back when I originally wrote xfs_scrub, I decided that phase 3 (the file
> scrubber) should try to open all regular files by handle to pin the file
> during the scrub.  At the time, I decided that an ESTALE return value
> should cause the entire inode group (aka an inobt record) to be
> rescanned for thoroughness reasons.
> 
> Over the past four years, I've realized that checking the return value
> here isn't necessary.  For most runtime errors, we already fall back to
> scrubbing with the file handle, at a fairly small performance cost.
> 
> For ESTALE, if the file has been freed and reallocated, its metadata has
> been rewritten completely since bulkstat, so it's not necessary to check
> it for latent disk errors.  If the file was freed, we can simply move on
> to the next file.  If the filesystem is corrupt enough that
> open-by-handle fails (this also results in ESTALE), we actually /want/
> to fall back to scrubbing that file by handle, not rescanning the entire
> inode group.
> 
> Therefore, remove the ESTALE check and leave a comment detailing these
> findings.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

ohhhkay, tbh mostly trusting you n this but it all; sounds plausible ;)

Reviewed-by: Eric Sandeen <sandeen@redhat.com>
