Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DD3F5F5D8F
	for <lists+linux-xfs@lfdr.de>; Thu,  6 Oct 2022 02:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbiJFAOs (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 5 Oct 2022 20:14:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbiJFAOp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Oct 2022 20:14:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDF14F007
        for <linux-xfs@vger.kernel.org>; Wed,  5 Oct 2022 17:14:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 53D8261750
        for <linux-xfs@vger.kernel.org>; Thu,  6 Oct 2022 00:14:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B45EC433C1;
        Thu,  6 Oct 2022 00:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665015280;
        bh=S4trj1xYx8O/tUXmG7bwiz8nYXtKDgZaPkGel3C9V+w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Yl9vcnLV7MrUFLaMNYcuWW0ECODTm+TqGBZOYJoA6ZOSl08NaHcoCPnq/lMayvfq7
         GsfE0+oS4qnwgmZitM6s5zrDYVcGXJF8UrPZHcvUXjaHLUtZAUYHH/NjehERxQNkJS
         tXFVilCvWq0mLkn2I/dzymA2gaMPPvsNBpcYJTFFljFhSWD5/UYJdWXQakdq7fUW7s
         j/ygWYFB4uvedNjpGJy76HARPL/BSyOXETzDVFrDam5XoYDqxtIOlbrSjtK6ZLkDaM
         ERXdUBPWqAWWQe88rAhu0uWM4prCqqGVb7GUzlgCEVMpyEZ3sVMuyjcIjLTaN+IlMa
         HZr+/yc2DbnNg==
Date:   Wed, 5 Oct 2022 17:14:40 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Catherine Hoang <catherine.hoang@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3] xfs: add LARP state transition diagram
Message-ID: <Yz4d8NC53oVfPhGP@magnolia>
References: <20221005233801.1731-1-catherine.hoang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221005233801.1731-1-catherine.hoang@oracle.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 05, 2022 at 04:38:01PM -0700, Catherine Hoang wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Add a state transition diagram documenting each logged attribute state
> and their transition conditions. The diagram can be built from the
> included text source file with PlantUML.
> 
> [cathhoan: add descriptions, links to docs, and diagram image]
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  Documentation/filesystems/xfs-larp-state.pu  | 103 ++++++++
>  Documentation/filesystems/xfs-larp-state.svg | 253 +++++++++++++++++++

How did you get it to pretty-print the svg?

This looks great!  I think the next step is to link this into the
rest of the documentation, but that's a separate patch.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>  2 files changed, 356 insertions(+)
>  create mode 100644 Documentation/filesystems/xfs-larp-state.pu
>  create mode 100644 Documentation/filesystems/xfs-larp-state.svg
> 
> diff --git a/Documentation/filesystems/xfs-larp-state.pu b/Documentation/filesystems/xfs-larp-state.pu
> new file mode 100644
> index 000000000000..7a54773665a6
> --- /dev/null
> +++ b/Documentation/filesystems/xfs-larp-state.pu
> @@ -0,0 +1,103 @@
> +/'
> +PlantUML documentation:
> +Getting started - https://plantuml.com/starting
> +State diagram - https://plantuml.com/state-diagram
> +'/
> +
> +@startuml
> +
> +state REMOTE_ADD {
> +	XFS_DAS_..._SET_RMT : find space for remote blocks
> +	XFS_DAS_..._ALLOC_RMT : allocate blocks and set remote value
> +
> +	XFS_DAS_..._SET_RMT --> XFS_DAS_..._ALLOC_RMT
> +}
> +
> +state ADD {
> +	XFS_DAS_SF_ADD : add attr to shortform fork
> +	XFS_DAS_LEAF_ADD : add attr to inode in leaf form
> +	XFS_DAS_NODE_ADD : add attr to node format attribute tree
> +
> +	state add_entry <<entryPoint>>
> +	state add_form <<choice>>
> +	add_entry --> add_form
> +	add_form --> XFS_DAS_SF_ADD : short form
> +	add_form --> XFS_DAS_LEAF_ADD : leaf form
> +	add_form --> XFS_DAS_NODE_ADD : node form
> +
> +	XFS_DAS_SF_ADD --> XFS_DAS_LEAF_ADD : Full or too large
> +	XFS_DAS_LEAF_ADD --> XFS_DAS_NODE_ADD : full or too large
> +
> +	XFS_DAS_LEAF_ADD --> XFS_DAS_..._SET_RMT : remote xattr
> +	XFS_DAS_NODE_ADD --> XFS_DAS_..._SET_RMT : remote xattr
> +}
> +
> +state REMOVE {
> +	XFS_DAS_SF_REMOVE : remove attr from shortform fork
> +	XFS_DAS_LEAF_REMOVE : remove attr from an inode in leaf form
> +	XFS_DAS_NODE_REMOVE : setup for removal
> +	XFS_DAS_NODE_REMOVE : (attr exists and blocks are valid)
> +
> +	state remove_entry <<entryPoint>>
> +	state remove_form <<choice>>
> +	remove_entry --> remove_form
> +	remove_form --> XFS_DAS_SF_REMOVE : short form
> +	remove_form --> XFS_DAS_LEAF_REMOVE : leaf form
> +	remove_form --> XFS_DAS_NODE_REMOVE : node form
> +}
> +
> +state REPLACE {
> +	state replace_choice <<choice>>
> +	replace_choice --> add_entry : larp disable
> +	replace_choice --> remove_entry : larp enabled
> +}
> +
> +
> +state OLD_REPLACE {
> +	XFS_DAS_..._REPLACE : atomic INCOMPLETE flag flip
> +	XFS_DAS_..._REMOVE_OLD : restore original xattr state for remove
> +	XFS_DAS_..._REMOVE_OLD : invalidate old xattr
> +
> +	XFS_DAS_..._REPLACE --> XFS_DAS_..._REMOVE_OLD
> +}
> +
> +state REMOVE_XATTR {
> +	XFS_DAS_..._REMOVE_RMT : remove remote attribute blocks
> +	XFS_DAS_..._REMOVE_ATTR : remove attribute name from leaf/node block
> +
> +	state remove_xattr_choice <<choice>>
> +	remove_xattr_choice --> XFS_DAS_..._REMOVE_RMT : Remote xattr
> +	remove_xattr_choice --> XFS_DAS_..._REMOVE_ATTR : Local xattr
> +
> +	XFS_DAS_..._REMOVE_RMT --> XFS_DAS_..._REMOVE_ATTR
> +}
> +
> +state XFS_DAS_DONE {
> +}
> +
> +state add_done <<choice>>
> +add_done -down-> XFS_DAS_DONE : Operation Complete
> +add_done -up-> XFS_DAS_..._REPLACE : LARP disabled REPLACE
> +XFS_DAS_SF_ADD -down-> add_done : Success
> +XFS_DAS_LEAF_ADD -down-> add_done : Success
> +XFS_DAS_NODE_ADD -down-> add_done : Success
> +XFS_DAS_..._ALLOC_RMT -down-> add_done : Success
> +
> +state remove_done <<choice>>
> +remove_done -down-> XFS_DAS_DONE : Operation Complete
> +remove_done -up-> add_entry : LARP enabled REPLACE
> +XFS_DAS_SF_REMOVE -down-> remove_done : Success
> +XFS_DAS_LEAF_REMOVE -down-> remove_done : Success
> +XFS_DAS_NODE_REMOVE -down-> remove_done : Success
> +XFS_DAS_..._REMOVE_ATTR -down-> remove_done : Success
> +
> +XFS_DAS_..._REMOVE_OLD --> remove_xattr_choice
> +XFS_DAS_NODE_REMOVE --> remove_xattr_choice
> +
> +state set_choice <<choice>>
> +[*] --> set_choice
> +set_choice --> add_entry : add new
> +set_choice --> remove_entry : remove existing
> +set_choice --> replace_choice : replace existing
> +XFS_DAS_DONE --> [*]
> +@enduml
> diff --git a/Documentation/filesystems/xfs-larp-state.svg b/Documentation/filesystems/xfs-larp-state.svg
> new file mode 100644
> index 000000000000..860fe2b59093
> --- /dev/null
> +++ b/Documentation/filesystems/xfs-larp-state.svg
> @@ -0,0 +1,253 @@
> +<?xml version="1.0" encoding="UTF-8" standalone="no"?>
> +<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" contentScriptType="application/ecmascript" contentStyleType="text/css" height="1462px" preserveAspectRatio="none" style="width:1857px;height:1462px" version="1.1" viewBox="0 0 1857 1462" width="1857px" zoomAndPan="magnify">
> +  <defs>
> +    <filter height="300%" id="fc2ynpqha1fpc" width="300%" x="-1" y="-1">
> +      <feGaussianBlur result="blurOut" stdDeviation="2.0"/>
> +      <feColorMatrix in="blurOut" result="blurOut2" type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 .4 0"/>
> +      <feOffset dx="4.0" dy="4.0" in="blurOut2" result="blurOut3"/>
> +      <feBlend in="SourceGraphic" in2="blurOut3" mode="normal"/>
> +    </filter>
> +  </defs>
> +  <g>
> +    <!--cluster REMOTE_ADD-->
> +    <rect fill="#FEFECE" filter="url(#fc2ynpqha1fpc)" height="230" rx="12.5" ry="12.5" style="stroke:#A80036;stroke-width:1.5" width="284" x="188" y="926"/>
> +    <rect fill="#FFFFFF" height="197.7031" rx="12.5" ry="12.5" style="stroke:#FFFFFF;stroke-width:1.0" width="278" x="191" y="955.2969"/>
> +    <line style="stroke:#A80036;stroke-width:1.5" x1="188" x2="472" y1="952.2969" y2="952.2969"/>
> +    <text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacingAndGlyphs" textLength="98" x="281" y="942.9951">REMOTE_ADD</text>
> +    <!--cluster ADD-->
> +    <rect fill="#FEFECE" filter="url(#fc2ynpqha1fpc)" height="559" rx="12.5" ry="12.5" style="stroke:#A80036;stroke-width:1.5" width="384" x="43" y="320"/>
> +    <rect fill="#FFFFFF" height="526.7031" rx="12.5" ry="12.5" style="stroke:#FFFFFF;stroke-width:1.0" width="378" x="46" y="349.2969"/>
> +    <line style="stroke:#A80036;stroke-width:1.5" x1="43" x2="427" y1="346.2969" y2="346.2969"/>
> +    <text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacingAndGlyphs" textLength="31" x="219.5" y="337.9951">ADD</text>
> +    <!--cluster REMOVE-->
> +    <rect fill="#FEFECE" filter="url(#fc2ynpqha1fpc)" height="295" rx="12.5" ry="12.5" style="stroke:#A80036;stroke-width:1.5" width="804" x="1041" y="320"/>
> +    <rect fill="#FFFFFF" height="262.7031" rx="12.5" ry="12.5" style="stroke:#FFFFFF;stroke-width:1.0" width="798" x="1044" y="349.2969"/>
> +    <line style="stroke:#A80036;stroke-width:1.5" x1="1041" x2="1845" y1="346.2969" y2="346.2969"/>
> +    <text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacingAndGlyphs" textLength="60" x="1413" y="337.9951">REMOVE</text>
> +    <!--cluster REPLACE-->
> +    <rect fill="#FEFECE" filter="url(#fc2ynpqha1fpc)" height="75" rx="12.5" ry="12.5" style="stroke:#A80036;stroke-width:1.5" width="79" x="683" y="176"/>
> +    <rect fill="#FFFFFF" height="42.7031" rx="12.5" ry="12.5" style="stroke:#FFFFFF;stroke-width:1.0" width="73" x="686" y="205.2969"/>
> +    <line style="stroke:#A80036;stroke-width:1.5" x1="683" x2="762" y1="202.2969" y2="202.2969"/>
> +    <text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacingAndGlyphs" textLength="63" x="691" y="192.9951">REPLACE</text>
> +    <!--cluster OLD_REPLACE-->
> +    <rect fill="#FEFECE" filter="url(#fc2ynpqha1fpc)" height="242" rx="12.5" ry="12.5" style="stroke:#A80036;stroke-width:1.5" width="290" x="739" y="373"/>
> +    <rect fill="#FFFFFF" height="209.7031" rx="12.5" ry="12.5" style="stroke:#FFFFFF;stroke-width:1.0" width="284" x="742" y="402.2969"/>
> +    <line style="stroke:#A80036;stroke-width:1.5" x1="739" x2="1029" y1="399.2969" y2="399.2969"/>
> +    <text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacingAndGlyphs" textLength="99" x="834.5" y="389.9951">OLD_REPLACE</text>
> +    <!--cluster REMOVE_XATTR-->
> +    <rect fill="#FEFECE" filter="url(#fc2ynpqha1fpc)" height="363" rx="12.5" ry="12.5" style="stroke:#A80036;stroke-width:1.5" width="389" x="873" y="664"/>
> +    <rect fill="#FFFFFF" height="330.7031" rx="12.5" ry="12.5" style="stroke:#FFFFFF;stroke-width:1.0" width="383" x="876" y="693.2969"/>
> +    <line style="stroke:#A80036;stroke-width:1.5" x1="873" x2="1262" y1="690.2969" y2="690.2969"/>
> +    <text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacingAndGlyphs" textLength="113" x="1011" y="680.9951">REMOVE_XATTR</text>
> +    <rect fill="#FEFECE" filter="url(#fc2ynpqha1fpc)" height="50.2656" rx="12.5" ry="12.5" style="stroke:#A80036;stroke-width:1.5" width="199" x="230.5" y="961"/>
> +    <line style="stroke:#A80036;stroke-width:1.5" x1="230.5" x2="429.5" y1="987.2969" y2="987.2969"/>
> +    <text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacingAndGlyphs" textLength="153" x="253.5" y="978.9951">XFS_DAS_..._SET_RMT</text>
> +    <text fill="#000000" font-family="sans-serif" font-size="12" lengthAdjust="spacingAndGlyphs" textLength="179" x="235.5" y="1003.4355">find space for remote blocks</text>
> +    <rect fill="#FEFECE" filter="url(#fc2ynpqha1fpc)" height="50.2656" rx="12.5" ry="12.5" style="stroke:#A80036;stroke-width:1.5" width="252" x="204" y="1090"/>
> +    <line style="stroke:#A80036;stroke-width:1.5" x1="204" x2="456" y1="1116.2969" y2="1116.2969"/>
> +    <text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacingAndGlyphs" textLength="170" x="245" y="1107.9951">XFS_DAS_..._ALLOC_RMT</text>
> +    <text fill="#000000" font-family="sans-serif" font-size="12" lengthAdjust="spacingAndGlyphs" textLength="232" x="209" y="1132.4355">allocate blocks and set remote value</text>
> +    <rect fill="#FEFECE" filter="url(#fc2ynpqha1fpc)" height="50.2656" rx="12.5" ry="12.5" style="stroke:#A80036;stroke-width:1.5" width="181" x="96.5" y="542"/>
> +    <line style="stroke:#A80036;stroke-width:1.5" x1="96.5" x2="277.5" y1="568.2969" y2="568.2969"/>
> +    <text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacingAndGlyphs" textLength="124" x="125" y="559.9951">XFS_DAS_SF_ADD</text>
> +    <text fill="#000000" font-family="sans-serif" font-size="12" lengthAdjust="spacingAndGlyphs" textLength="161" x="101.5" y="584.4355">add attr to shortform fork</text>
> +    <rect fill="#FEFECE" filter="url(#fc2ynpqha1fpc)" height="50.2656" rx="12.5" ry="12.5" style="stroke:#A80036;stroke-width:1.5" width="201" x="205.5" y="686"/>
> +    <line style="stroke:#A80036;stroke-width:1.5" x1="205.5" x2="406.5" y1="712.2969" y2="712.2969"/>
> +    <text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacingAndGlyphs" textLength="140" x="236" y="703.9951">XFS_DAS_LEAF_ADD</text>
> +    <text fill="#000000" font-family="sans-serif" font-size="12" lengthAdjust="spacingAndGlyphs" textLength="181" x="210.5" y="728.4355">add attr to inode in leaf form</text>
> +    <rect fill="#FEFECE" filter="url(#fc2ynpqha1fpc)" height="50.2656" rx="12.5" ry="12.5" style="stroke:#A80036;stroke-width:1.5" width="258" x="59" y="813"/>
> +    <line style="stroke:#A80036;stroke-width:1.5" x1="59" x2="317" y1="839.2969" y2="839.2969"/>
> +    <text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacingAndGlyphs" textLength="148" x="114" y="830.9951">XFS_DAS_NODE_ADD</text>
> +    <text fill="#000000" font-family="sans-serif" font-size="12" lengthAdjust="spacingAndGlyphs" textLength="238" x="64" y="855.4355">add attr to node format attribute tree</text>
> +    <text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacingAndGlyphs" textLength="68" x="375" y="298.6982">add_entry</text>
> +    <ellipse cx="409" cy="320" fill="#FEFECE" rx="6" ry="6" style="stroke:#A80036;stroke-width:1.5"/>
> +    <polygon fill="#FEFECE" filter="url(#fc2ynpqha1fpc)" points="289,421,301,433,289,445,277,433,289,421" style="stroke:#A80036;stroke-width:1.5"/>
> +    <rect fill="#FEFECE" filter="url(#fc2ynpqha1fpc)" height="50.2656" rx="12.5" ry="12.5" style="stroke:#A80036;stroke-width:1.5" width="218" x="1318" y="542"/>
> +    <line style="stroke:#A80036;stroke-width:1.5" x1="1318" x2="1536" y1="568.2969" y2="568.2969"/>
> +    <text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacingAndGlyphs" textLength="153" x="1350.5" y="559.9951">XFS_DAS_SF_REMOVE</text>
> +    <text fill="#000000" font-family="sans-serif" font-size="12" lengthAdjust="spacingAndGlyphs" textLength="198" x="1323" y="584.4355">remove attr from shortform fork</text>
> +    <rect fill="#FEFECE" filter="url(#fc2ynpqha1fpc)" height="50.2656" rx="12.5" ry="12.5" style="stroke:#A80036;stroke-width:1.5" width="258" x="1571" y="542"/>
> +    <line style="stroke:#A80036;stroke-width:1.5" x1="1571" x2="1829" y1="568.2969" y2="568.2969"/>
> +    <text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacingAndGlyphs" textLength="169" x="1615.5" y="559.9951">XFS_DAS_LEAF_REMOVE</text>
> +    <text fill="#000000" font-family="sans-serif" font-size="12" lengthAdjust="spacingAndGlyphs" textLength="238" x="1576" y="584.4355">remove attr from an inode in leaf form</text>
> +    <rect fill="#FEFECE" filter="url(#fc2ynpqha1fpc)" height="64.2344" rx="12.5" ry="12.5" style="stroke:#A80036;stroke-width:1.5" width="222" x="1061" y="535"/>
> +    <line style="stroke:#A80036;stroke-width:1.5" x1="1061" x2="1283" y1="561.2969" y2="561.2969"/>
> +    <text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacingAndGlyphs" textLength="177" x="1083.5" y="552.9951">XFS_DAS_NODE_REMOVE</text>
> +    <text fill="#000000" font-family="sans-serif" font-size="12" lengthAdjust="spacingAndGlyphs" textLength="110" x="1066" y="577.4355">setup for removal</text>
> +    <text fill="#000000" font-family="sans-serif" font-size="12" lengthAdjust="spacingAndGlyphs" textLength="202" x="1066" y="591.4043">(attr exists and blocks are valid)</text>
> +    <text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacingAndGlyphs" textLength="94" x="1012" y="298.6982">remove_entry</text>
> +    <ellipse cx="1059" cy="320" fill="#FEFECE" rx="6" ry="6" style="stroke:#A80036;stroke-width:1.5"/>
> +    <polygon fill="#FEFECE" filter="url(#fc2ynpqha1fpc)" points="1299,421,1311,433,1299,445,1287,433,1299,421" style="stroke:#A80036;stroke-width:1.5"/>
> +    <polygon fill="#FEFECE" filter="url(#fc2ynpqha1fpc)" points="722,211,734,223,722,235,710,223,722,211" style="stroke:#A80036;stroke-width:1.5"/>
> +    <rect fill="#FEFECE" filter="url(#fc2ynpqha1fpc)" height="50.2656" rx="12.5" ry="12.5" style="stroke:#A80036;stroke-width:1.5" width="191" x="771.5" y="408"/>
> +    <line style="stroke:#A80036;stroke-width:1.5" x1="771.5" x2="962.5" y1="434.2969" y2="434.2969"/>
> +    <text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacingAndGlyphs" textLength="151" x="791.5" y="425.9951">XFS_DAS_..._REPLACE</text>
> +    <text fill="#000000" font-family="sans-serif" font-size="12" lengthAdjust="spacingAndGlyphs" textLength="171" x="776.5" y="450.4355">atomic INCOMPLETE flag flip</text>
> +    <rect fill="#FEFECE" filter="url(#fc2ynpqha1fpc)" height="64.2344" rx="12.5" ry="12.5" style="stroke:#A80036;stroke-width:1.5" width="257" x="755.5" y="535"/>
> +    <line style="stroke:#A80036;stroke-width:1.5" x1="755.5" x2="1012.5" y1="561.2969" y2="561.2969"/>
> +    <text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacingAndGlyphs" textLength="184" x="792" y="552.9951">XFS_DAS_..._REMOVE_OLD</text>
> +    <text fill="#000000" font-family="sans-serif" font-size="12" lengthAdjust="spacingAndGlyphs" textLength="237" x="760.5" y="577.4355">restore original xattr state for remove</text>
> +    <text fill="#000000" font-family="sans-serif" font-size="12" lengthAdjust="spacingAndGlyphs" textLength="116" x="760.5" y="591.4043">invalidate old xattr</text>
> +    <rect fill="#FEFECE" filter="url(#fc2ynpqha1fpc)" height="50.2656" rx="12.5" ry="12.5" style="stroke:#A80036;stroke-width:1.5" width="218" x="889" y="813"/>
> +    <line style="stroke:#A80036;stroke-width:1.5" x1="889" x2="1107" y1="839.2969" y2="839.2969"/>
> +    <text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacingAndGlyphs" textLength="186" x="905" y="830.9951">XFS_DAS_..._REMOVE_RMT</text>
> +    <text fill="#000000" font-family="sans-serif" font-size="12" lengthAdjust="spacingAndGlyphs" textLength="198" x="894" y="855.4355">remove remote attribute blocks</text>
> +    <rect fill="#FEFECE" filter="url(#fc2ynpqha1fpc)" height="50.2656" rx="12.5" ry="12.5" style="stroke:#A80036;stroke-width:1.5" width="296" x="950" y="961"/>
> +    <line style="stroke:#A80036;stroke-width:1.5" x1="950" x2="1246" y1="987.2969" y2="987.2969"/>
> +    <text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacingAndGlyphs" textLength="192" x="1002" y="978.9951">XFS_DAS_..._REMOVE_ATTR</text>
> +    <text fill="#000000" font-family="sans-serif" font-size="12" lengthAdjust="spacingAndGlyphs" textLength="276" x="955" y="1003.4355">remove attribute name from leaf/node block</text>
> +    <polygon fill="#FEFECE" filter="url(#fc2ynpqha1fpc)" points="1107,699,1119,711,1107,723,1095,711,1107,699" style="stroke:#A80036;stroke-width:1.5"/>
> +    <polygon fill="#FEFECE" filter="url(#fc2ynpqha1fpc)" points="424,1219,436,1231,424,1243,412,1231,424,1219" style="stroke:#A80036;stroke-width:1.5"/>
> +    <polygon fill="#FEFECE" filter="url(#fc2ynpqha1fpc)" points="1242,1103,1254,1115,1242,1127,1230,1115,1242,1103" style="stroke:#A80036;stroke-width:1.5"/>
> +    <polygon fill="#FEFECE" filter="url(#fc2ynpqha1fpc)" points="722,89,734,101,722,113,710,101,722,89" style="stroke:#A80036;stroke-width:1.5"/>
> +    <ellipse cx="722" cy="18" fill="#000000" filter="url(#fc2ynpqha1fpc)" rx="10" ry="10" style="stroke:none;stroke-width:1.0"/>
> +    <ellipse cx="717" cy="1441" fill="none" filter="url(#fc2ynpqha1fpc)" rx="10" ry="10" style="stroke:#000000;stroke-width:1.0"/>
> +    <ellipse cx="717.5" cy="1441.5" fill="#000000" rx="6" ry="6" style="stroke:none;stroke-width:1.0"/>
> +    <rect fill="#FEFECE" filter="url(#fc2ynpqha1fpc)" height="50" rx="12.5" ry="12.5" style="stroke:#A80036;stroke-width:1.5" width="130" x="652" y="1320"/>
> +    <line style="stroke:#A80036;stroke-width:1.5" x1="652" x2="782" y1="1346.2969" y2="1346.2969"/>
> +    <text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacingAndGlyphs" textLength="110" x="662" y="1337.9951">XFS_DAS_DONE</text>
> +    <!--link XFS_DAS_..._SET_RMT to XFS_DAS_..._ALLOC_RMT-->
> +    <path d="M330,1011.19 C330,1032.11 330,1062.41 330,1084.71 " fill="none" id="XFS_DAS_..._SET_RMT-XFS_DAS_..._ALLOC_RMT" style="stroke:#A80036;stroke-width:1.0"/>
> +    <polygon fill="#A80036" points="330,1089.9,334,1080.9,330,1084.9,326,1080.9,330,1089.9" style="stroke:#A80036;stroke-width:1.0"/>
> +    <!--link add_entry to add_form-->
> +    <path d="M405.01,324.69 C388.25,340.2 323.3,400.28 298.6,423.12 " fill="none" id="add_entry-add_form" style="stroke:#A80036;stroke-width:1.0"/>
> +    <polygon fill="#A80036" points="294.74,426.69,304.0612,423.5096,298.4085,423.2927,298.6255,417.64,294.74,426.69" style="stroke:#A80036;stroke-width:1.0"/>
> +    <!--link add_form to XFS_DAS_SF_ADD-->
> +    <path d="M284.08,440.37 C270.71,457.67 233.1,506.34 208.81,537.78 " fill="none" id="add_form-XFS_DAS_SF_ADD" style="stroke:#A80036;stroke-width:1.0"/>
> +    <polygon fill="#A80036" points="205.62,541.91,214.2877,537.2333,208.6768,537.9533,207.9569,532.3424,205.62,541.91" style="stroke:#A80036;stroke-width:1.0"/>
> +    <text fill="#000000" font-family="sans-serif" font-size="13" lengthAdjust="spacingAndGlyphs" textLength="67" x="248" y="501.0669">short form</text>
> +    <!--link add_form to XFS_DAS_LEAF_ADD-->
> +    <path d="M294.32,440.15 C302.24,449.68 316.96,468.92 324,488 C346.2,548.15 338.77,567.03 343,631 C343.5,638.54 345.01,640.72 343,648 C339.76,659.74 333.66,671.49 327.32,681.56 " fill="none" id="add_form-XFS_DAS_LEAF_ADD" style="stroke:#A80036;stroke-width:1.0"/>
> +    <polygon fill="#A80036" points="324.6,685.77,332.8445,680.3822,327.3139,681.5706,326.1255,676.04,324.6,685.77" style="stroke:#A80036;stroke-width:1.0"/>
> +    <text fill="#000000" font-family="sans-serif" font-size="13" lengthAdjust="spacingAndGlyphs" textLength="57" x="343" y="571.5669">leaf form</text>
> +    <!--link add_form to XFS_DAS_NODE_ADD-->
> +    <path d="M279.12,435.14 C244.13,439.78 125.73,460.68 79,535 C21.34,626.71 114.04,753.21 162.04,808.84 " fill="none" id="add_form-XFS_DAS_NODE_ADD" style="stroke:#A80036;stroke-width:1.0"/>
> +    <polygon fill="#A80036" points="165.41,812.72,162.5343,803.3003,162.1337,808.943,156.4911,808.5424,165.41,812.72" style="stroke:#A80036;stroke-width:1.0"/>
> +    <text fill="#000000" font-family="sans-serif" font-size="13" lengthAdjust="spacingAndGlyphs" textLength="66" x="69" y="644.0669">node form</text>
> +    <!--link XFS_DAS_SF_ADD to XFS_DAS_LEAF_ADD-->
> +    <path d="M200.19,592.24 C209.69,608.72 223.37,630.61 238,648 C248.26,660.19 260.84,672.29 272.39,682.52 " fill="none" id="XFS_DAS_SF_ADD-XFS_DAS_LEAF_ADD" style="stroke:#A80036;stroke-width:1.0"/>
> +    <polygon fill="#A80036" points="276.26,685.92,272.1376,676.9754,272.5033,682.6204,266.8583,682.9861,276.26,685.92" style="stroke:#A80036;stroke-width:1.0"/>
> +    <text fill="#000000" font-family="sans-serif" font-size="13" lengthAdjust="spacingAndGlyphs" textLength="99" x="239" y="644.0669">Full or too large</text>
> +    <!--link XFS_DAS_LEAF_ADD to XFS_DAS_NODE_ADD-->
> +    <path d="M283.25,736.1 C263.5,757.03 234.89,787.32 214.19,809.25 " fill="none" id="XFS_DAS_LEAF_ADD-XFS_DAS_NODE_ADD" style="stroke:#A80036;stroke-width:1.0"/>
> +    <polygon fill="#A80036" points="210.68,812.97,219.7611,809.1577,214.1068,809.329,213.9355,803.6747,210.68,812.97" style="stroke:#A80036;stroke-width:1.0"/>
> +    <text fill="#000000" font-family="sans-serif" font-size="13" lengthAdjust="spacingAndGlyphs" textLength="96" x="255" y="779.0669">full or too large</text>
> +    <!--link XFS_DAS_LEAF_ADD to XFS_DAS_..._SET_RMT-->
> +    <path d="M338.34,736.22 C347.05,744.59 355.33,754.73 360,766 C386.58,830.18 360.57,913.1 343.05,956.16 " fill="none" id="XFS_DAS_LEAF_ADD-XFS_DAS_..._SET_RMT" style="stroke:#A80036;stroke-width:1.0"/>
> +    <polygon fill="#A80036" points="341.07,960.96,348.206,954.172,342.9809,956.3396,340.8133,951.1145,341.07,960.96" style="stroke:#A80036;stroke-width:1.0"/>
> +    <text fill="#000000" font-family="sans-serif" font-size="13" lengthAdjust="spacingAndGlyphs" textLength="81" x="372" y="842.5669">remote xattr</text>
> +    <!--link XFS_DAS_NODE_ADD to XFS_DAS_..._SET_RMT-->
> +    <path d="M211.45,863.11 C236.53,888.89 276.25,929.74 302.71,956.94 " fill="none" id="XFS_DAS_NODE_ADD-XFS_DAS_..._SET_RMT" style="stroke:#A80036;stroke-width:1.0"/>
> +    <polygon fill="#A80036" points="306.52,960.86,303.1148,951.6185,303.0348,957.2748,297.3785,957.1948,306.52,960.86" style="stroke:#A80036;stroke-width:1.0"/>
> +    <text fill="#000000" font-family="sans-serif" font-size="13" lengthAdjust="spacingAndGlyphs" textLength="81" x="255" y="906.0669">remote xattr</text>
> +    <!--link remove_entry to remove_form-->
> +    <path d="M1064.01,323.32 C1093.31,336.87 1242.6,405.91 1286.71,426.32 " fill="none" id="remove_entry-remove_form" style="stroke:#A80036;stroke-width:1.0"/>
> +    <polygon fill="#A80036" points="1291.33,428.45,1284.839,421.0428,1286.7915,426.352,1281.4822,428.3044,1291.33,428.45" style="stroke:#A80036;stroke-width:1.0"/>
> +    <!--link remove_form to XFS_DAS_SF_REMOVE-->
> +    <path d="M1304.5,439.67 C1320.69,456.36 1368.95,506.14 1399.84,538 " fill="none" id="remove_form-XFS_DAS_SF_REMOVE" style="stroke:#A80036;stroke-width:1.0"/>
> +    <polygon fill="#A80036" points="1403.52,541.79,1400.1148,532.5485,1400.0348,538.2048,1394.3785,538.1248,1403.52,541.79" style="stroke:#A80036;stroke-width:1.0"/>
> +    <text fill="#000000" font-family="sans-serif" font-size="13" lengthAdjust="spacingAndGlyphs" textLength="67" x="1367" y="501.0669">short form</text>
> +    <!--link remove_form to XFS_DAS_LEAF_REMOVE-->
> +    <path d="M1307.38,436.76 C1347.18,449.86 1519.53,506.59 1622.18,540.38 " fill="none" id="remove_form-XFS_DAS_LEAF_REMOVE" style="stroke:#A80036;stroke-width:1.0"/>
> +    <polygon fill="#A80036" points="1627.01,541.97,1619.7068,535.3622,1622.2595,540.4103,1617.2113,542.963,1627.01,541.97" style="stroke:#A80036;stroke-width:1.0"/>
> +    <text fill="#000000" font-family="sans-serif" font-size="13" lengthAdjust="spacingAndGlyphs" textLength="57" x="1512" y="501.0669">leaf form</text>
> +    <!--link remove_form to XFS_DAS_NODE_REMOVE-->
> +    <path d="M1293.54,439.67 C1278.62,455.18 1236.24,499.23 1205.72,530.96 " fill="none" id="remove_form-XFS_DAS_NODE_REMOVE" style="stroke:#A80036;stroke-width:1.0"/>
> +    <polygon fill="#A80036" points="1202.06,534.76,1211.1866,531.0579,1205.5307,531.1608,1205.4278,525.5049,1202.06,534.76" style="stroke:#A80036;stroke-width:1.0"/>
> +    <text fill="#000000" font-family="sans-serif" font-size="13" lengthAdjust="spacingAndGlyphs" textLength="66" x="1247" y="501.0669">node form</text>
> +    <!--link replace_choice to add_entry-->
> +    <path d="M715.58,229 C700.21,240.69 659.7,269.88 621,284 C547.76,310.72 452.81,317.14 420.41,318.6 " fill="none" id="replace_choice-add_entry" style="stroke:#A80036;stroke-width:1.0"/>
> +    <polygon fill="#A80036" points="415.11,318.81,424.273,322.421,420.1054,318.5959,423.9305,314.4283,415.11,318.81" style="stroke:#A80036;stroke-width:1.0"/>
> +    <text fill="#000000" font-family="sans-serif" font-size="13" lengthAdjust="spacingAndGlyphs" textLength="73" x="657" y="280.0669">larp disable</text>
> +    <!--link replace_choice to remove_entry-->
> +    <path d="M730.32,226.84 C756.8,235.83 841.65,264.27 913,284 C963.24,297.89 1024.07,311.44 1048.3,316.7 " fill="none" id="replace_choice-remove_entry" style="stroke:#A80036;stroke-width:1.0"/>
> +    <polygon fill="#A80036" points="1053.39,317.8,1045.4395,311.9871,1048.5031,316.7426,1043.7476,319.8062,1053.39,317.8" style="stroke:#A80036;stroke-width:1.0"/>
> +    <text fill="#000000" font-family="sans-serif" font-size="13" lengthAdjust="spacingAndGlyphs" textLength="79" x="914" y="280.0669">larp enabled</text>
> +    <!--link XFS_DAS_..._REPLACE to XFS_DAS_..._REMOVE_OLD-->
> +    <path d="M870.12,458.21 C872.7,478.28 876.41,507.1 879.35,529.89 " fill="none" id="XFS_DAS_..._REPLACE-XFS_DAS_..._REMOVE_OLD" style="stroke:#A80036;stroke-width:1.0"/>
> +    <polygon fill="#A80036" points="880,534.95,882.8093,525.5103,879.357,529.9915,874.8758,526.5392,880,534.95" style="stroke:#A80036;stroke-width:1.0"/>
> +    <!--link remove_xattr_choice to XFS_DAS_..._REMOVE_RMT-->
> +    <path d="M1101.74,718.03 C1087.66,734.18 1048.4,779.2 1022.42,809 " fill="none" id="remove_xattr_choice-XFS_DAS_..._REMOVE_RMT" style="stroke:#A80036;stroke-width:1.0"/>
> +    <polygon fill="#A80036" points="1019,812.91,1027.9279,808.7516,1022.2844,809.14,1021.896,803.4965,1019,812.91" style="stroke:#A80036;stroke-width:1.0"/>
> +    <text fill="#000000" font-family="sans-serif" font-size="13" lengthAdjust="spacingAndGlyphs" textLength="84" x="1060" y="779.0669">Remote xattr</text>
> +    <!--link remove_xattr_choice to XFS_DAS_..._REMOVE_ATTR-->
> +    <path d="M1113.32,716.81 C1123.94,725.33 1145,744.27 1153,766 C1155.61,773.09 1154,775.51 1153,783 C1144.59,845.92 1122.05,917.01 1108.58,955.84 " fill="none" id="remove_xattr_choice-XFS_DAS_..._REMOVE_ATTR" style="stroke:#A80036;stroke-width:1.0"/>
> +    <polygon fill="#A80036" points="1106.82,960.87,1113.5521,953.6812,1108.4609,956.1469,1105.9952,951.0557,1106.82,960.87" style="stroke:#A80036;stroke-width:1.0"/>
> +    <text fill="#000000" font-family="sans-serif" font-size="13" lengthAdjust="spacingAndGlyphs" textLength="67" x="1148" y="842.5669">Local xattr</text>
> +    <!--link XFS_DAS_..._REMOVE_RMT to XFS_DAS_..._REMOVE_ATTR-->
> +    <path d="M1014.51,863.11 C1032.1,888.79 1059.92,929.4 1078.55,956.61 " fill="none" id="XFS_DAS_..._REMOVE_RMT-XFS_DAS_..._REMOVE_ATTR" style="stroke:#A80036;stroke-width:1.0"/>
> +    <polygon fill="#A80036" points="1081.46,960.86,1079.6731,951.1746,1078.634,956.7352,1073.0734,955.6962,1081.46,960.86" style="stroke:#A80036;stroke-width:1.0"/>
> +    <!--link add_done to XFS_DAS_DONE-->
> +    <path d="M432.14,1235.11 C463.07,1246.94 575.27,1289.82 649.28,1318.11 " fill="none" id="add_done-XFS_DAS_DONE" style="stroke:#A80036;stroke-width:1.0"/>
> +    <polygon fill="#A80036" points="654.1,1319.95,647.1215,1313.0001,649.4296,1318.1647,644.265,1320.4727,654.1,1319.95" style="stroke:#A80036;stroke-width:1.0"/>
> +    <text fill="#000000" font-family="sans-serif" font-size="13" lengthAdjust="spacingAndGlyphs" textLength="129" x="571" y="1286.0669">Operation Complete</text>
> +    <!--link XFS_DAS_..._REPLACE to add_done-->
> +    <path d="M793.93,460.12 C749.79,481.09 702,515.46 702,566 C702,566 702,566 702,902.5 C702,1037.15 636.85,1061.95 549,1164 C516.18,1202.13 455.77,1221.51 433,1227.73 " fill="none" id="XFS_DAS_..._REPLACE-add_done" style="stroke:#A80036;stroke-width:1.0"/>
> +    <polygon fill="#A80036" points="798.46,458.01,788.6128,458.1929,793.9294,460.1252,791.9972,465.4418,798.46,458.01" style="stroke:#A80036;stroke-width:1.0"/>
> +    <text fill="#000000" font-family="sans-serif" font-size="13" lengthAdjust="spacingAndGlyphs" textLength="150" x="703" y="842.5669">LARP disabled REPLACE</text>
> +    <!--link XFS_DAS_SF_ADD to add_done-->
> +    <path d="M114.94,592.05 C64.47,613.96 6,651.89 6,710 C6,710 6,710 6,1116 C6,1201.03 331.99,1224.78 408.2,1229.18 " fill="none" id="XFS_DAS_SF_ADD-add_done" style="stroke:#A80036;stroke-width:1.0"/>
> +    <polygon fill="#A80036" points="413.25,1229.46,404.4801,1224.978,408.2574,1229.189,404.0464,1232.9663,413.25,1229.46" style="stroke:#A80036;stroke-width:1.0"/>
> +    <text fill="#000000" font-family="sans-serif" font-size="13" lengthAdjust="spacingAndGlyphs" textLength="53" x="7" y="906.0669">Success</text>
> +    <!--link XFS_DAS_LEAF_ADD to add_done-->
> +    <path d="M406.56,730.32 C463.32,747.11 523,778.63 523,837 C523,837 523,837 523,1116 C523,1168.56 462.26,1208.72 435.93,1223.66 " fill="none" id="XFS_DAS_LEAF_ADD-add_done" style="stroke:#A80036;stroke-width:1.0"/>
> +    <polygon fill="#A80036" points="431.44,1226.16,441.25,1225.2858,435.8108,1223.7318,437.3648,1218.2926,431.44,1226.16" style="stroke:#A80036;stroke-width:1.0"/>
> +    <text fill="#000000" font-family="sans-serif" font-size="13" lengthAdjust="spacingAndGlyphs" textLength="53" x="524" y="990.5669">Success</text>
> +    <!--link XFS_DAS_NODE_ADD to add_done-->
> +    <path d="M174.11,863.2 C152.55,903.85 115.24,988.43 133,1060 C145.59,1110.75 147.29,1131.18 188,1164 C255.99,1218.82 366.69,1228.16 407.89,1229.71 " fill="none" id="XFS_DAS_NODE_ADD-add_done" style="stroke:#A80036;stroke-width:1.0"/>
> +    <polygon fill="#A80036" points="413.01,1229.87,404.1523,1225.564,408.0129,1229.6987,403.8782,1233.5593,413.01,1229.87" style="stroke:#A80036;stroke-width:1.0"/>
> +    <text fill="#000000" font-family="sans-serif" font-size="13" lengthAdjust="spacingAndGlyphs" textLength="53" x="134" y="1056.0669">Success</text>
> +    <!--link XFS_DAS_..._ALLOC_RMT to add_done-->
> +    <path d="M349.93,1140.18 C370.21,1164.76 400.66,1201.7 415.4,1219.57 " fill="none" id="XFS_DAS_..._ALLOC_RMT-add_done" style="stroke:#A80036;stroke-width:1.0"/>
> +    <polygon fill="#A80036" points="418.8,1223.69,416.1738,1214.1977,415.6245,1219.8279,409.9943,1219.2786,418.8,1223.69" style="stroke:#A80036;stroke-width:1.0"/>
> +    <text fill="#000000" font-family="sans-serif" font-size="13" lengthAdjust="spacingAndGlyphs" textLength="53" x="389" y="1185.0669">Success</text>
> +    <!--link remove_done to XFS_DAS_DONE-->
> +    <path d="M1234.17,1119.4 C1183.73,1141.3 902.74,1263.34 777.39,1317.77 " fill="none" id="remove_done-XFS_DAS_DONE" style="stroke:#A80036;stroke-width:1.0"/>
> +    <polygon fill="#A80036" points="772.63,1319.84,782.4784,1319.9343,777.2183,1317.8532,779.2995,1312.5931,772.63,1319.84" style="stroke:#A80036;stroke-width:1.0"/>
> +    <text fill="#000000" font-family="sans-serif" font-size="13" lengthAdjust="spacingAndGlyphs" textLength="129" x="997" y="1235.5669">Operation Complete</text>
> +    <!--link add_entry to remove_done-->
> +    <path d="M418.16,326.32 C441.07,340.4 499,381.04 499,432 C499,432 499,432 499,640.5 C499,684.61 504.38,697.56 526,736 C625.8,913.44 687.15,951.91 873,1035 C1006.08,1094.49 1186.57,1110.25 1231.53,1113.35 " fill="none" id="add_entry-remove_done" style="stroke:#A80036;stroke-width:1.0"/>
> +    <polygon fill="#A80036" points="413.84,323.73,419.4797,331.8043,418.1212,326.313,423.6125,324.9544,413.84,323.73" style="stroke:#A80036;stroke-width:1.0"/>
> +    <text fill="#000000" font-family="sans-serif" font-size="13" lengthAdjust="spacingAndGlyphs" textLength="148" x="527" y="715.5669">LARP enabled REPLACE</text>
> +    <!--link XFS_DAS_SF_REMOVE to remove_done-->
> +    <path d="M1430.83,592.05 C1434.97,620.23 1441,668.38 1441,710 C1441,710 1441,710 1441,987 C1441,1074.24 1303.43,1104.2 1257.06,1111.83 " fill="none" id="XFS_DAS_SF_REMOVE-remove_done" style="stroke:#A80036;stroke-width:1.0"/>
> +    <polygon fill="#A80036" points="1251.87,1112.65,1261.3875,1115.1832,1256.8076,1111.8628,1260.128,1107.283,1251.87,1112.65" style="stroke:#A80036;stroke-width:1.0"/>
> +    <text fill="#000000" font-family="sans-serif" font-size="13" lengthAdjust="spacingAndGlyphs" textLength="53" x="1442" y="842.5669">Success</text>
> +    <!--link XFS_DAS_LEAF_REMOVE to remove_done-->
> +    <path d="M1680.62,592.02 C1660.83,619.03 1633,665.02 1633,710 C1633,710 1633,710 1633,987 C1633,1067.52 1329.29,1104.76 1257.21,1112.46 " fill="none" id="XFS_DAS_LEAF_REMOVE-remove_done" style="stroke:#A80036;stroke-width:1.0"/>
> +    <polygon fill="#A80036" points="1252.06,1113,1261.4238,1116.0527,1257.0335,1112.4855,1260.6006,1108.0951,1252.06,1113" style="stroke:#A80036;stroke-width:1.0"/>
> +    <text fill="#000000" font-family="sans-serif" font-size="13" lengthAdjust="spacingAndGlyphs" textLength="53" x="1634" y="842.5669">Success</text>
> +    <!--link XFS_DAS_NODE_REMOVE to remove_done-->
> +    <path d="M1234.32,599.03 C1273.24,623.26 1316,661.02 1316,710 C1316,710 1316,710 1316,987 C1316,1037.48 1271.82,1085.78 1251.73,1105.12 " fill="none" id="XFS_DAS_NODE_REMOVE-remove_done" style="stroke:#A80036;stroke-width:1.0"/>
> +    <polygon fill="#A80036" points="1248.06,1108.6,1257.3489,1105.3263,1251.6943,1105.166,1251.8545,1099.5115,1248.06,1108.6" style="stroke:#A80036;stroke-width:1.0"/>
> +    <text fill="#000000" font-family="sans-serif" font-size="13" lengthAdjust="spacingAndGlyphs" textLength="53" x="1317" y="842.5669">Success</text>
> +    <!--link XFS_DAS_..._REMOVE_ATTR to remove_done-->
> +    <path d="M1125.42,1011.19 C1157.86,1039.79 1210.2,1085.95 1231.98,1105.17 " fill="none" id="XFS_DAS_..._REMOVE_ATTR-remove_done" style="stroke:#A80036;stroke-width:1.0"/>
> +    <polygon fill="#A80036" points="1235.92,1108.64,1231.8338,1099.6788,1232.1767,1105.3253,1226.5302,1105.6682,1235.92,1108.64" style="stroke:#A80036;stroke-width:1.0"/>
> +    <text fill="#000000" font-family="sans-serif" font-size="13" lengthAdjust="spacingAndGlyphs" textLength="53" x="1179" y="1056.0669">Success</text>
> +    <!--link XFS_DAS_..._REMOVE_OLD to remove_xattr_choice-->
> +    <path d="M932.94,599.16 C985.76,632.8 1066.27,684.06 1095.71,702.81 " fill="none" id="XFS_DAS_..._REMOVE_OLD-remove_xattr_choice" style="stroke:#A80036;stroke-width:1.0"/>
> +    <polygon fill="#A80036" points="1099.99,705.53,1094.5499,697.3199,1095.7735,702.8428,1090.2505,704.0664,1099.99,705.53" style="stroke:#A80036;stroke-width:1.0"/>
> +    <!--link XFS_DAS_NODE_REMOVE to remove_xattr_choice-->
> +    <path d="M1157.74,599.16 C1143.62,630 1122.72,675.66 1112.73,697.49 " fill="none" id="XFS_DAS_NODE_REMOVE-remove_xattr_choice" style="stroke:#A80036;stroke-width:1.0"/>
> +    <polygon fill="#A80036" points="1110.54,702.26,1117.9134,695.7306,1112.6144,697.7106,1110.6344,692.4116,1110.54,702.26" style="stroke:#A80036;stroke-width:1.0"/>
> +    <!--link *start to set_choice-->
> +    <path d="M722,28.29 C722,41.73 722,66.81 722,83.45 " fill="none" id="*start-set_choice" style="stroke:#A80036;stroke-width:1.0"/>
> +    <polygon fill="#A80036" points="722,88.75,726,79.75,722,83.75,718,79.75,722,88.75" style="stroke:#A80036;stroke-width:1.0"/>
> +    <!--link set_choice to add_entry-->
> +    <path d="M715.46,106.53 C675.48,134.25 464.17,280.75 417.94,312.8 " fill="none" id="set_choice-add_entry" style="stroke:#A80036;stroke-width:1.0"/>
> +    <polygon fill="#A80036" points="413.56,315.84,423.2339,313.9919,417.6668,312.988,418.6707,307.421,413.56,315.84" style="stroke:#A80036;stroke-width:1.0"/>
> +    <text fill="#000000" font-family="sans-serif" font-size="13" lengthAdjust="spacingAndGlyphs" textLength="53" x="627" y="227.5669">add new</text>
> +    <!--link set_choice to remove_entry-->
> +    <path d="M730.92,104.39 C750.14,109.72 796.57,123.68 832,143 C926.76,194.66 1023.54,284.76 1051.19,311.39 " fill="none" id="set_choice-remove_entry" style="stroke:#A80036;stroke-width:1.0"/>
> +    <polygon fill="#A80036" points="1055.03,315.1,1051.3279,305.9734,1051.4308,311.6293,1045.7749,311.7322,1055.03,315.1" style="stroke:#A80036;stroke-width:1.0"/>
> +    <text fill="#000000" font-family="sans-serif" font-size="13" lengthAdjust="spacingAndGlyphs" textLength="102" x="994" y="227.5669">remove existing</text>
> +    <!--link set_choice to replace_choice-->
> +    <path d="M722,113.07 C722,134.33 722,180.92 722,205.72 " fill="none" id="set_choice-replace_choice" style="stroke:#A80036;stroke-width:1.0"/>
> +    <polygon fill="#A80036" points="722,210.95,726,201.95,722,205.95,718,201.95,722,210.95" style="stroke:#A80036;stroke-width:1.0"/>
> +    <text fill="#000000" font-family="sans-serif" font-size="13" lengthAdjust="spacingAndGlyphs" textLength="100" x="723" y="156.0669">replace existing</text>
> +    <!--link XFS_DAS_DONE to *end-->
> +    <path d="M717,1370.21 C717,1387.84 717,1411.13 717,1425.84 " fill="none" id="XFS_DAS_DONE-*end" style="stroke:#A80036;stroke-width:1.0"/>
> +    <polygon fill="#A80036" points="717,1430.84,721,1421.84,717,1425.84,713,1421.84,717,1430.84" style="stroke:#A80036;stroke-width:1.0"/>
> +  </g>
> +</svg>
> -- 
> 2.25.1
> 
